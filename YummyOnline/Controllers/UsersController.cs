﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using YummyOnlineDAO.Models;
using Protocol;

namespace YummyOnline.Controllers {
	[Authorize(Roles = nameof(Role.Admin))]
	public class UsersController : BaseController {
		// GET: Users
		public ActionResult Index() {
			return View();
		}

		public ActionResult _ViewCustomer() {
			return View();
		}
		public ActionResult _ViewNemo() {
			return View();
		}
		public ActionResult _ViewAdmin() {
			return View();
		}
		public ActionResult _ViewHotelAdmin() {
			return View();
		}

		#region Admins
		public async Task<JsonResult> GetAdmins() {
			return Json(await YummyOnlineManager.GetUsers(Role.Admin));
		}

		[Authorize(Roles = nameof(Role.SuperAdmin))]
		public async Task<JsonResult> AddAdmin(string phoneNumber) {
			User user = await UserManager.FindByPhoneNumberAsync(phoneNumber);
			if(user == null) {
				return Json(new JsonError("此手机号未注册"));
			}
			if(await UserManager.IsInRoleAsync(user.Id, Role.Admin)) {
				return Json(new JsonError("已经为管理员"));
			}
			await UserManager.AddToRoleAsync(user.Id, Role.Admin);
			await YummyOnlineManager.RecordLog(Log.LogProgram.System, Log.LogLevel.Success, $"User {user.Id} Added to Admin");
			return Json(new JsonSuccess());
		}

		[Authorize(Roles = nameof(Role.SuperAdmin))]
		public async Task<JsonResult> DeleteAdmin(string id) {
			await UserManager.RemoveFromRoleAsync(id, Role.Admin);
			await YummyOnlineManager.RecordLog(Log.LogProgram.System, Log.LogLevel.Warning, $"User {id} Removed from Admin");
			return Json(new JsonSuccess());
		}
		#endregion

		#region Nemoes
		public async Task<JsonResult> GetNemoes(int countPerPage, int currPage) {
			return Json(new {
				Users = await YummyOnlineManager.GetUsers(Role.Nemo, countPerPage, currPage, true),
				Count = await YummyOnlineManager.GetUserCount(Role.Nemo)
			});
		}
		[Authorize(Roles = nameof(Role.SuperAdmin))]
		public async Task<JsonResult> DeleteNemoesHavenotDine() {
			await YummyOnlineManager.DeleteNemoesHavenotDine();
			return Json(new JsonSuccess());
		}
		#endregion

		#region Customers
		public async Task<JsonResult> GetCustomers(int countPerPage, int currPage) {
			return Json(new {
				Users = await YummyOnlineManager.GetUsers(Role.Customer, countPerPage, currPage, true),
				Count = await YummyOnlineManager.GetUserCount(Role.Customer)
			});
		}
		#endregion

		public async Task<JsonResult> GetHotelAdmins() {
			return Json(await YummyOnlineManager.GetHotelAdmins());
		}

		public async Task<JsonResult> GetUserDines(string userId) {
			return Json(await YummyOnlineManager.GetDinesByUserId(userId));
		}
	}
}