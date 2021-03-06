﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Fleck;
using YummyOnlineDAO.Models;
using System.Timers;
using Utility;
using Protocol;
using System.Diagnostics;
using Newtonsoft.Json;
using System.Runtime.InteropServices;

namespace YummyOnlineTcpServer {
	public class WebSocketServer {
		[DllImport("kernel32.dll")]
		[return: MarshalAs(UnmanagedType.Bool)]
		private static extern bool GetPhysicallyInstalledSystemMemory(out long TotalMemoryInKilobytes);

		public WebSocketServer(string ip, int port, Action<string, Log.LogLevel> logDelegate) {
			GetPhysicallyInstalledSystemMemory(out memorySize);

			FleckLog.Level = LogLevel.Error + 1;
			Fleck.WebSocketServer server = new Fleck.WebSocketServer($"ws://{ip}:{port}");
			this.logDelegate = logDelegate;
			server.Start(serverConnected);

			try {
				IISManager.GetSites().ForEach(info => {
					siteCurrentConnections.Add(new PerformanceCounter("Web Service", "Current Connections", info.Name));
				});
			}
			catch { }


			Timer timer = new Timer(1000);
			timer.Elapsed += Timer_Elapsed;
			timer.Start();
		}

		public List<IWebSocketConnection> AllSockets { get; set; } = new List<IWebSocketConnection>();
		private Action<string, Log.LogLevel> logDelegate;

		private PerformanceCounter cputime = new PerformanceCounter("Processor Information", "% Processor Time", "_Total");
		private PerformanceCounter diskIdle = new PerformanceCounter("PhysicalDisk", "% Idle Time", "_Total");
		private PerformanceCounter memoryCounter = new PerformanceCounter("Process", "Working Set", "_Total");
		private List<PerformanceCounter> siteCurrentConnections = new List<PerformanceCounter>();
		private long memorySize;

		private Queue<ServerInfoWebSocketProtocol> historyProtocols = new Queue<ServerInfoWebSocketProtocol>();

		private void serverConnected(IWebSocketConnection socket) {
			socket.OnOpen = () => {
				logDelegate($"{socket.ConnectionInfo.ClientIpAddress}:{socket.ConnectionInfo.ClientPort} WebSocket Open", Log.LogLevel.Success);
				foreach(var p in historyProtocols) {
					socket.Send(JsonConvert.SerializeObject(p));
				}
				AllSockets.Add(socket);
			};
			socket.OnClose = () => {
				logDelegate($"{socket.ConnectionInfo.ClientIpAddress}:{socket.ConnectionInfo.ClientPort} WebSocket Close", Log.LogLevel.Warning);
				AllSockets.Remove(socket);
			};
			socket.OnError = e => {
				logDelegate($"{socket.ConnectionInfo.ClientIpAddress}:{socket.ConnectionInfo.ClientPort} WebSocket Error, {e.Message}", Log.LogLevel.Error);
				AllSockets.Remove(socket);
			};
		}
		
		private void Timer_Elapsed(object sender, ElapsedEventArgs e) {
			ServerInfoWebSocketProtocol protocol = new ServerInfoWebSocketProtocol();

			protocol.CpuTime = cputime.NextValue();
			protocol.DiskIdle = diskIdle.NextValue();
			protocol.MemoryUsage = memoryCounter.NextValue() / 1024 / memorySize * 100;

			siteCurrentConnections.ForEach(s => {
				protocol.SitePerformances.Add(new SitePerformance {
					Name = s.InstanceName,
					CurrentConnections = s.NextValue()
				});
			});

			if(historyProtocols.Count >= 50) {
				historyProtocols.Dequeue();
			}
			historyProtocols.Enqueue(protocol);

			AllSockets.ForEach(s => {
				s.Send(JsonConvert.SerializeObject(protocol));
			});
		}
	}
}
