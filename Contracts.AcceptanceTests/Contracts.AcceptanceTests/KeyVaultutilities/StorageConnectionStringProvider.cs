using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SFA.FCT.Contracts.AcceptanceTests
{

    public static class StorageConnectionStringProvider
    {
        // Set once during test initialization
        public static string StorageConnectionString { get; set; }

        public static string Get()
        {
            // ✅ Test / CI / Acceptance path
            if (!string.IsNullOrWhiteSpace(StorageConnectionString))
            {
                return StorageConnectionString;
            }

            // ✅ Production / local fallback
            return ConfigurationManager
                .ConnectionStrings["StorageConnectionString"]
                .ConnectionString;
        }
    }

}
