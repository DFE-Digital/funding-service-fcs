namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using Services;

    public static class CrmFundingTypeRepository
    {
        public static sfa_fundingtype FindById(Guid id)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.sfa_fundingtypeSet
                    .Single(ft => ft.Id == id);
            }
        }
    }
}
