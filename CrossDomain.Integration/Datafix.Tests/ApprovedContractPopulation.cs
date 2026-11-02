namespace Datafix.Tests
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    [TestClass]
    public class ApprovedContractPopulation
    {
        [TestMethod, TestCategory("DataFix_R40")]
        public void ApprovedContract_PopulateFundingTypeAndFundingPeriod()
        {
            using (var context = new ContractManagementDbContext())
            {
                List<ApprovedContract> approvedContracts = context.ApprovedContracts.ToList();
                Parallel.ForEach(approvedContracts, new ParallelOptions { MaxDegreeOfParallelism = 12 }, approvedContract =>
                {
                    FundingTypeFundingPeriod fundingTypeFundingPeriod = GetFundingTypeFundingPeriodForContract(approvedContract.ContractNumber,
                        approvedContract.ContractVersionNumber, approvedContract.ContractSubVersionNumber);
                    if (fundingTypeFundingPeriod != null)
                    {
                        //Commented the following 2 lines as the properties are now private set. This is an data fix from R40. We are working on R46
                        //approvedContract.FundingType = fundingTypeFundingPeriod.FundingType;
                        //approvedContract.FundingPeriod = fundingTypeFundingPeriod.FundingPeriod;
                    }
                });

                context.SaveChanges();
            }
        }

        private FundingTypeFundingPeriod GetFundingTypeFundingPeriodForContract(string contractNumber, int version, int subVersion)
        {
            using (var xrmContext = new XrmServiceContext(new OrganizationService(GetCrmConnection())))
            {
                return (from c in xrmContext.sfa_contractSet
                        join ft in xrmContext.sfa_fundingtypeSet on c.sfa_FundingType.Id equals ft.sfa_fundingtypeId
                        join p in xrmContext.sfa_periodSet on c.sfa_PeriodId.Id equals p.sfa_periodId
                        where c.sfa_number == contractNumber
                        && c.sfa_Version == version
                        && c.sfa_SubVersion == subVersion
                        select new FundingTypeFundingPeriod { FundingType = ft.sfa_fundingtypecode, FundingPeriod = p.sfa_periodname}).FirstOrDefault();
            }
        }

        private class FundingTypeFundingPeriod
        {
            public string FundingType { get; set; }

            public string FundingPeriod { get; set; }
        }

        private static CrmConnection GetCrmConnection()
        {
            return CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);
        }
    }
}
