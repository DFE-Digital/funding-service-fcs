namespace FCT.Console.Config.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class CrmContractNumberRepository : ICrmContractNumberRepository
    {
        public int? GetCurrentContractNumber(ContractNumberType contractNumberType, string context)
        {
            if (contractNumberType == ContractNumberType.Master)
            {
                return GetCurrentMasterContractNumber(context);
            }
            if (contractNumberType == ContractNumberType.Contract)
            {
                return GetCurrentContractNumber(context);
            }
            if (contractNumberType == ContractNumberType.Allocation)
            {
                return GetCurrentAllocationNumber(context);
            }

            throw new ArgumentException("ContractNumberType not set");
        }

        public static int? GetCurrentContractNumber(string fundingTypeCode)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetOrganizationService()))
            {
                List<int?> contractNumberList = (from cn in xrmContext.sfa_contractnumberSet
                    join f in xrmContext.sfa_fundingtypeSet on cn.sfa_FundingTypeId.Id equals f.sfa_fundingtypeId

                    where f.sfa_fundingtypecode == fundingTypeCode
                                    select cn.sfa_lastnumber).ToList();

                return contractNumberList.SingleOrDefault();
            }
        }

        public static int? GetCurrentAllocationNumber(string fundingStreamCode)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetOrganizationService()))
            {
                var contractNumberList = (from cn in xrmContext.sfa_contractnumberSet
                    join fs in xrmContext.sfa_fundingstreamSet on cn.sfa_FundingStreamId.Id equals fs.sfa_fundingstreamId

                    where fs.sfa_fundingstreamcode == fundingStreamCode
                                          select cn.sfa_lastnumber).ToList();

                return contractNumberList.SingleOrDefault();
            }
        }

        public static int? GetCurrentMasterContractNumber(string agencyShortCode)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetOrganizationService()))
            {
                var contractNumberList = (from cn in xrmContext.sfa_contractnumberSet
                    join a in xrmContext.sfa_agencySet on cn.sfa_AgencyId.Id equals a.sfa_agencyId

                    where a.sfa_agencyshortcode == agencyShortCode
                    select cn.sfa_lastnumber).ToList();

                return contractNumberList.SingleOrDefault();
            }
        }
    }
}
