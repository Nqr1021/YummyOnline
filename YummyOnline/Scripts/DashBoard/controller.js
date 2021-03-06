﻿app.controller('DashBoardCtrl', [
	'$scope',
	'$http',
	'$filter',
	'layout',
	function ($scope, $http, $filter, $layout) {
		$layout.Set('概览', '');

		$scope.refreshUserLine = function () {

			$http.post('/DashBoard/GetUserDailyCount').then(function (response) {
				var data = response.data;
				var userCount = {
					categories: [],
					customerDailyCount: [],
					nemoDailyCount: []
				}
				for (var i in data.CustomerDailyCount) {
					var date = new Date(data.CustomerDailyCount[i].DateTime);
					userCount.categories.push($filter('date')(date, 'MM-dd'));

					userCount.customerDailyCount.push(data.CustomerDailyCount[i].Count);
				}
				for (var i in data.NemoDailyCount) {
					userCount.nemoDailyCount.push(data.NemoDailyCount[i].Count)
				}

				$('#user-line').highcharts({
					title: null,
					chart: {
						type: 'spline',
					},

					xAxis: {
						categories: userCount.categories,
						tickInterval: 7,
					},
					yAxis: {
						title: null
					},

					plotOptions: {
						series: {
							marker: {
								lineWidth: 1
							}
						},
						spline: {
							marker: {
								enabled: true
							}
						}
					},
					series: [{
						name: '普通用户',
						data: userCount.customerDailyCount
					}, {
						name: '匿名用户',
						data: userCount.nemoDailyCount
					}]
				});
			});
		}

		$scope.refreshDineLine = function () {
			$http.post('/DashBoard/GetDineDailyCount').then(function (response) {
				var categories = [];
				var series = [];
				var data = response.data;
				for (var i in data) {
					series.push({
						name: data[i].HotelName,
						data: []
					});
					for (var j in data[i].DailyCount) {
						if (i == 0) {
							var date = new Date(data[i].DailyCount[j].DateTime);
							categories.push($filter('date')(date, 'MM-dd'));
						}
						series[i].data.push(data[i].DailyCount[j].Count);
					}
				}

				$('#dine-line').highcharts({
					title: null,
					chart: {
						type: 'spline',
					},
					xAxis: {
						categories: categories,
						tickInterval: 7,
					},
					yAxis: {
						title: null
					},

					plotOptions: {
						series: {
							marker: {
								lineWidth: 1
							}
						},
						spline: {
							marker: {
								enabled: true
							}
						}
					},
					series: series
				});
			});
		}

		$scope.refreshDinePerHourLine = function () {
			$http.post('/DashBoard/GetDinePerHourCount', {
				'DateTime': $scope.currDateTime
			}).then(function (response) {
				var categories = [];
				var series = [];
				var data = response.data;
				for (var i in data) {
					series.push({
						name: data[i].HotelName,
						data: []
					});
					for (var j in data[i].Counts) {
						if (i == 0) {
							categories.push(j + ' - ' + (parseInt(j) + 1));
						}
						series[i].data.push(data[i].Counts[j]);
					}
				}

				$('#dine-perhour-line').highcharts({
					title: null,
					chart: {
						height: 300,
						type: 'spline',
					},
					xAxis: {
						categories: categories,
						tickInterval: 5
					},
					yAxis: {
						title: null
					},

					plotOptions: {
						series: {
							marker: {
								lineWidth: 1
							}
						},
						spline: {
							marker: {
								enabled: true
							}
						}
					},
					series: series
				});
			});
		}

		$scope.refreshUserLine();
		$scope.refreshDineLine();
		$scope.$watch('currDateTime', function () {
			$scope.refreshDinePerHourLine();
		});

	}
]);

app.controller('MonitorCtrl', [
	'$scope',
	'websocket',
	'layout',
	function ($scope, $websocket, $layout) {
		$layout.Set('实时监控', '');

		$scope.$watch('websocketLocation', function (location) {
			$websocket.Initialize(location);
		});

		var $cpuLine = $('#cpu-line').highcharts({
			title: null,
			chart: {
				type: 'line',
				height: 200,
				animation: false,
			},

			xAxis: {
				type: 'datetime',
				tickPixelInterval: 150
			},
			yAxis: {
				title: null,
				max: 100,
				min: 0
			},
			plotOptions: {
				line: {
					marker: {
						enabled: false,
					}
				}
			},
			tooltip: {
				enabled: false
			},
			legend: {
				enabled: false
			},
			series: [{
				data: []
			}]
		});
		var $memoryLine = $('#memory-line').highcharts({
			title: null,
			chart: {
				type: 'line',
				height: 200,
				animation: false,
			},

			xAxis: {
				type: 'datetime',
				tickPixelInterval: 150
			},
			yAxis: {
				title: null,
				max: 100,
				min: 0
			},
			plotOptions: {
				line: {
					marker: {
						enabled: false,
					}
				}
			},
			tooltip: {
				enabled: false
			},
			legend: {
				enabled: false
			},
			series: [{
				data: []
			}]
		});
		var $diskLine = $('#disk-line').highcharts({
			title: null,
			chart: {
				type: 'line',
				height: 200,
				animation: false,
			},
			xAxis: {
				type: 'datetime',
				tickPixelInterval: 150
			},
			yAxis: {
				title: null,
				max: 100,
				min: 0
			},
			plotOptions: {
				line: {
					marker: {
						enabled: false,
					}
				}
			},
			tooltip: {
				enabled: false
			},
			legend: {
				enabled: false
			},
			series: [{
				data: []
			}]
		});

		var $iisLine = $('#iis-line').highcharts({
			title: null,
			chart: {
				type: 'line',
				animation: false
			},

			xAxis: {
				type: 'datetime',
				tickPixelInterval: 150
			},
			yAxis: {
				title: null,
			},
			tooltip: {
				enabled: false
			},
			series: []
		});

		var isInit = false;
		$scope.$on('WebSocketMessageReceived', function (event, data) {
			var cpuLine = $cpuLine.highcharts();
			var memoryLine = $memoryLine.highcharts();
			var diskLine = $diskLine.highcharts();

			var shift = cpuLine.series[0].data.length >= 50;
			var dateTime = new Date(data.DateTime).getTime();
			dateTime += 8 * 60 * 60 * 1000;

			cpuLine.series[0].addPoint([dateTime, data.CpuTime], true, shift);
			memoryLine.series[0].addPoint([dateTime, data.MemoryUsage], true, shift);
			diskLine.series[0].addPoint([dateTime, 100 - data.DiskIdle], true, shift);


			var iisLine = $iisLine.highcharts();
			for (var i in data.SitePerformances) {
				if (!isInit) {
					iisLine.addSeries({
						name: data.SitePerformances[i].Name,
						data: []
					});
				}
				iisLine.series[i].addPoint([dateTime, data.SitePerformances[i].CurrentConnections], true, shift);
			}

			isInit = true;
		});
	}
])