﻿using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.SqlServer;
using System.Linq;
using System.Threading.Tasks;
using YummyOnlineDAO.Models;
using Utility;

namespace OrderSystem {
	public class YummyOnlineManager : YummyOnlineDAO.YummyOnlineManager {
		public async Task<Protocol.PrintingProtocol.Hotel> GetHotelForPrintingById(int hotelId) {
			return await ctx.Hotels
				.Where(p => p.Id == hotelId)
				.Select(p => new Protocol.PrintingProtocol.Hotel {
					Id = p.Id,
					Name = p.Name,
					Address = p.Address,
					OpenTime = p.OpenTime,
					CloseTime = p.CloseTime,
					Tel = p.Tel,
					Usable = p.Usable
				}).FirstOrDefaultAsync();
		}

		public async Task<Protocol.PrintingProtocol.User> GetUserForPrintingById(string userId) {
			return await ctx.Users
				.Where(p => p.Id == userId)
				.Select(p => new Protocol.PrintingProtocol.User {
					Id = p.Id,
					Email = p.Email,
					UserName = p.UserName,
					PhoneNumber = p.PhoneNumber
				}).FirstOrDefaultAsync();
		}
	}
}
