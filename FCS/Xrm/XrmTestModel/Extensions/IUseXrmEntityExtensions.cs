namespace XrmTestModel.Extensions
{
    using System;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public static class XrmEntityExtensions
    {
        public static Guid GetId<T>(this IUseXrmEntity<T> source) where T : Entity
        {
            return source.EntityId.Value;
        }

        public static EntityReference GetEntityReference<T>(this IUseXrmEntity<T> source) where T : Entity
        {
            return source.Entity.ToEntityReference();
        }

        public static void DeleteEntity<T>(this IUseXrmEntity<T> source, IOrganizationService orgService) where T : Entity
        {
            if (source.Entity != null)
            {
                orgService.Delete(source.EntityLogicalName, source.EntityId.Value);
            }

            source.EntityId = null;
            source.Entity = null;
        }

        public static void SaveEntity<T>(this IUseXrmEntity<T> source, IOrganizationService orgService) where T : Entity
        {
            using (var xrmSvcContext = new XrmServiceContext(orgService))
            {
                source.TranslateToXrm();
                if (!source.EntityId.HasValue)
                {
                    xrmSvcContext.AddObject(source.Entity);
                }
                else
                {
                    xrmSvcContext.Attach(source.Entity);
                    xrmSvcContext.UpdateObject(source.Entity);
                }
                xrmSvcContext.SaveChanges();
                source.EntityId = source.Entity.Id;
            }
        }
    }
}
