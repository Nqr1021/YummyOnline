﻿using Newtonsoft.Json;
using System;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Mvc;
using Utility;
using YummyOnlineDAO.Identity;
using YummyOnlineDAO.Models;

namespace OrderSystem.Controllers {
	public class BaseController : Controller {
		protected override JsonResult Json(object data, string contentType, Encoding contentEncoding, JsonRequestBehavior behavior) {
			return new JsonNetResult {
				Data = data,
				ContentType = contentType,
				ContentEncoding = contentEncoding,
				JsonRequestBehavior = behavior
			};
		}
		
		private YummyOnlineManager _yummyOnlineManager;
		public YummyOnlineManager YummyOnlineManager {
			get {
				if(_yummyOnlineManager == null) {
					_yummyOnlineManager = new YummyOnlineManager();
				}
				return _yummyOnlineManager;
			}
		}

		public class CurrHotelInfo {
			public CurrHotelInfo(int id, string connectionString) {
				Id = id;
				ConnectionString = connectionString;
			}
			public CurrHotelInfo(Hotel hotel) {
				Id = hotel.Id;
				ConnectionString = hotel.ConnectionString;
			}
			public int Id { get; set; }
			public string ConnectionString { get; set; }
		}
		public CurrHotelInfo CurrHotel {
			get {
				return (CurrHotelInfo)Session["Hotel"];
			}
			set {
				Session["Hotel"] = value;
			}
		}
	}

	public abstract class BaseOrderSystemController : BaseController {
		private UserManager _userManager;
		public UserManager UserManager {
			get {
				if(_userManager == null) {
					_userManager = new UserManager();
				}
				return _userManager;
			}
		}
		private UserSigninManager _signinManager;
		public UserSigninManager SigninManager {
			get {
				if(_signinManager == null) {
					_signinManager = new UserSigninManager(HttpContext);
				}
				return _signinManager;
			}
		}

		private HotelManager _hotelManager;
		public HotelManager HotelManager {
			get {
				if(_hotelManager == null) {
					_hotelManager = new HotelManager(CurrHotel.ConnectionString);
				}
				return _hotelManager;
			}
		}

		protected override void OnActionExecuted(ActionExecutedContext filterContext) {
			if(CurrHotel != null) {
				ViewBag.HotelId = CurrHotel?.Id;
				ViewBag.CssThemePath = AsyncInline.Run(() => { return YummyOnlineManager.GetHotelById(CurrHotel.Id); }).CssThemePath;
			}

			base.OnActionExecuted(filterContext);
		}
	}

	public class JsonNetResult : JsonResult {
		public JsonSerializerSettings Settings { get; private set; }

		public JsonNetResult() {
			Settings = new JsonSerializerSettings {
				ReferenceLoopHandling = ReferenceLoopHandling.Ignore
			};
		}

		public override void ExecuteResult(ControllerContext context) {
			if(context == null)
				throw new ArgumentNullException("context");
			if(this.JsonRequestBehavior == JsonRequestBehavior.DenyGet && string.Equals(context.HttpContext.Request.HttpMethod, "GET", StringComparison.OrdinalIgnoreCase))
				throw new InvalidOperationException("JSON GET is not allowed");
			HttpResponseBase response = context.HttpContext.Response;
			response.ContentType = string.IsNullOrEmpty(this.ContentType) ? "application/json" : this.ContentType;
			if(this.ContentEncoding != null)
				response.ContentEncoding = this.ContentEncoding;
			if(this.Data == null)
				return;
			var scriptSerializer = JsonSerializer.Create(this.Settings);
			using(var sw = new StringWriter()) {
				scriptSerializer.Serialize(sw, this.Data);
				response.Write(sw.ToString());
			}
		}
	}

	/// <summary>
	/// 必须有饭店信息Session
	/// </summary>
	public class RequireHotelAttribute : ActionFilterAttribute {
		public override void OnActionExecuting(ActionExecutingContext filterContext) {
			HttpContextBase context = filterContext.HttpContext;
			if(context.Session["Hotel"] == null) {
				filterContext.Result = new RedirectResult("/Error/HotelMissing");
				return;
			}

			base.OnActionExecuting(filterContext);
		}
	}
	/// <summary>
	/// 饭店必须可用
	/// </summary>
	public class HotelAvailableAttribute : ActionFilterAttribute {
		public override void OnActionExecuting(ActionExecutingContext filterContext) {
			Hotel currHotel = filterContext.HttpContext.Session["Hotel"] as Hotel;
			if(currHotel != null) {
				Hotel hotel = AsyncInline.Run(() => new YummyOnlineManager().GetHotelById(currHotel.Id));
				if(!hotel.Usable) {
					filterContext.Result = new RedirectResult("/Error/HotelUnavailable");
					return;
				}
			}

			base.OnActionExecuting(filterContext);
		}
	}
}