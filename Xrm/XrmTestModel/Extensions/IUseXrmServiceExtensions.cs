using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace XrmTestModel.Extensions
{
    public static class IUseXrmServiceExtensions
    {
        public static void DefaultUser(this IUseXrmService source)
        {
            source.OrgService = source.OrgServiceFactory.Create();
        }

        public static void SwitchUser(this IUseXrmService source, string username)
        {
            source.OrgService = source.OrgServiceFactory.Create(username);
        }
    }
}
