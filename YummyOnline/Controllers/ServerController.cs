﻿using System;
using System.Diagnostics;
using System.Threading.Tasks;
using System.Web.Mvc;
using YummyOnlineDAO;
using YummyOnlineDAO.Models;
using Protocol;
using Newtonsoft.Json;
using Utility;
using YummyOnline.Utility;

namespace YummyOnline.Controllers {
	[Authorize(Roles = nameof(Role.Admin))]
	public class ServerController : BaseController {

		public ActionResult Index() {
			return View();
		}
		public ActionResult _ViewIISStatus() {
			return View();
		}
		public ActionResult _ViewTcpServerStatus() {
			return View();
		}
		public ActionResult _ViewGuids() {
			return View();
		}

		public JsonResult GetIISInfo() {
			return Json(new {
				Sites = IISManager.GetSites(),
				W3wps = IISManager.GetWorkerProcesses()
			});
		}
		[Authorize(Roles = nameof(Role.SuperAdmin))]
		public async Task<JsonResult> StartSite(int siteId) {
			if(IISManager.StartSite(siteId)) {
				await YummyOnlineManager.RecordLog(Log.LogProgram.System, Log.LogLevel.Success, $"Site {IISManager.GetSiteById(siteId).Name} Started");
				return Json(new JsonSuccess());
			}
			return Json(new JsonError("无法启动"));
		}
		[Authorize(Roles = nameof(Role.SuperAdmin))]
		public async Task<JsonResult> StopSite(int siteId) {
			if(IISManager.StopSite(siteId)) {
				await YummyOnlineManager.RecordLog(Log.LogProgram.System, Log.LogLevel.Warning, $"Site {IISManager.GetSiteById(siteId).Name} Stoped");
				return Json(new JsonSuccess());
			}
			return Json(new JsonError("无法停止"));
		}

		public JsonResult GetTcpServerInfo() {
			return Json(TcpServerProcess.GetTcpServerInfo());
		}
		[Authorize(Roles = nameof(Role.SuperAdmin))]
		public async Task<JsonResult> StartTcpServer() {
			bool result = await TcpServerProcess.StartTcpServer();
			if(result) {
				await YummyOnlineManager.RecordLog(Log.LogProgram.System, Log.LogLevel.Success, "TcpServer Started");
				return Json(new JsonSuccess());
			}
			return Json(new JsonError("开启失败"));
		}

		[Authorize(Roles = nameof(Role.SuperAdmin))]
		public async Task<JsonResult> StopTcpServer() {
			bool result = TcpServerProcess.StopTcpServer();
			if(result) {
				await YummyOnlineManager.RecordLog(Log.LogProgram.System, Log.LogLevel.Warning, "TcpServer Stoped");
				return Json(new JsonSuccess());
			}
			return Json(new JsonError("关闭失败"));
		}

		private Process getTcpServerProcess() {
			Process[] processes = Process.GetProcessesByName("YummyOnlineTcpServer");
			if(processes.Length == 0) {
				return null;
			}
			return processes[0];
		}

		public async Task<JsonResult> GetGuids() {
			return Json(await YummyOnlineManager.GetGuids());
		}
		[Authorize(Roles = nameof(Role.SuperAdmin))]
		public async Task<JsonResult> AddGuid(Guid guid, string description) {
			if(!await YummyOnlineManager.AddGuid(new NewDineInformClientGuid {
				Guid = guid,
				Description = description
			})) {
				return Json(new JsonError());
			}
			SystemTcpClient.SendSystemCommand(SystemCommandType.RefreshNewDineClients);
			await YummyOnlineManager.RecordLog(Log.LogProgram.System, Log.LogLevel.Success, $"Guid {guid} ({description}) Added");
			return Json(new JsonSuccess());
		}
		[Authorize(Roles = nameof(Role.SuperAdmin))]
		public async Task<JsonResult> DeleteGuid(Guid guid) {
			if(!await YummyOnlineManager.DeleteGuid(guid)) {
				return Json(new JsonError());
			}
			SystemTcpClient.SendSystemCommand(SystemCommandType.RefreshNewDineClients);
			await YummyOnlineManager.RecordLog(Log.LogProgram.System, Log.LogLevel.Warning, $"Guid {guid} Removed");
			return Json(new JsonSuccess());
		}
	}
}