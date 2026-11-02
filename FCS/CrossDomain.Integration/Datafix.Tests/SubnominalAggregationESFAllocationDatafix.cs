namespace Datafix.Tests
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using MoreLinq;
    using PaymentGenerationDomain.Integration.DataStore;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class SubnominalAggregationEsfAllocationDatafix
    {
        private const string SubnominalCodeToDelete = "2671312";
        private const string SubnominalCodeToKeep = "2672322";

        private const string PaymentTypeCapping = "CAPPING";
        private const string PaymentTypeReconciliation = "RECONCILIATION";

        private static readonly SubnominalAggregationInfo[] SubnominalAggregations =
        {
            new SubnominalAggregationInfo { AllocationNumber = "ESF-2073", Period = "201610" },
            new SubnominalAggregationInfo { AllocationNumber = "ESF-2074", Period = "201609" },
            new SubnominalAggregationInfo { AllocationNumber = "ESF-2074", Period = "201610" },
            new SubnominalAggregationInfo { AllocationNumber = "ESF-2075", Period = "201609" },
            new SubnominalAggregationInfo { AllocationNumber = "ESF-2075", Period = "201610" },
            new SubnominalAggregationInfo { AllocationNumber = "ESF-2076", Period = "201609" },
            new SubnominalAggregationInfo { AllocationNumber = "ESF-2076", Period = "201610" },
            new SubnominalAggregationInfo { AllocationNumber = "ESF-2077", Period = "201609" },
            new SubnominalAggregationInfo { AllocationNumber = "ESF-2077", Period = "201610" },
            new SubnominalAggregationInfo { AllocationNumber = "ESF-2081", Period = "201610" },
            new SubnominalAggregationInfo { AllocationNumber = "ESF-2094", Period = "201610" },
            new SubnominalAggregationInfo { AllocationNumber = "ESF-2103", Period = "201609" },
            new SubnominalAggregationInfo { AllocationNumber = "ESF-2103", Period = "201610" }
        };

        [TestMethod, TestCategory("DataFix_R32")]
        public void ApplySubnominalDataFix()
        {
            using (var organizationService = new OrganizationService(new CrmConnection("CrmConnectionString")))
            using (var xrmServiceContext = new XrmServiceContext(organizationService))
            using (var dbContext = new PaymentGenerationDbContext())
            {
                ApplySubnominalDataFixInPaas(dbContext);
                ApplySubnominalDataFixInCrm(xrmServiceContext);
            }
        }

        private static void ApplySubnominalDataFixInPaas(PaymentGenerationDbContext dbContext)
        {
            SubnominalAggregations.ForEach(sa =>
            {
                // get the capping SubnominalAggregation record to be deleted
                SubnominalAggregation cappingSubnominalAggregationToDelete = dbContext.SubnominalAggregations
                    .SingleOrDefault(x => x.AllocationNumber == sa.AllocationNumber
                    && x.Period == sa.Period
                    && x.SubnominalCode == SubnominalCodeToDelete
                    && x.PaymentType == PaymentTypeCapping);

                if (cappingSubnominalAggregationToDelete != null)
                {
                    // set kept capping SubnominalAggregation IsPosted, IsSelectedForPayment values to the same as the deleted record
                    SubnominalAggregation cappingSubnominalAggregationToKeep = dbContext.SubnominalAggregations
                        .Single(x => x.AllocationNumber == sa.AllocationNumber
                                     && x.Period == sa.Period
                                     && x.SubnominalCode == SubnominalCodeToKeep
                                     && x.PaymentType == PaymentTypeCapping);

                    cappingSubnominalAggregationToKeep.PostedFlag = cappingSubnominalAggregationToDelete.PostedFlag;
                    cappingSubnominalAggregationToKeep.IsSelectedForPayment = cappingSubnominalAggregationToDelete.IsSelectedForPayment;

                    // remove PaaS SubnominalAggregation record for PaymentTypeCapping
                    dbContext.SubnominalAggregations.Remove(cappingSubnominalAggregationToDelete);
                }

                // get the reconciliation SubnominalAggregation record to be deleted
                SubnominalAggregation reconciliationSubnominalAggregationToDelete = dbContext.SubnominalAggregations
                    .SingleOrDefault(x => x.AllocationNumber == sa.AllocationNumber
                    && x.Period == sa.Period
                    && x.SubnominalCode == SubnominalCodeToDelete
                    && x.PaymentType == PaymentTypeReconciliation);

                if (reconciliationSubnominalAggregationToDelete != null)
                {
                    // set kept reconciliation SubnominalAggregation IsPosted, IsSelectedForPayment values to the same as the deleted record
                    SubnominalAggregation reconciliationSubnominalAggregationToKeep = dbContext.SubnominalAggregations
                        .Single(x => x.AllocationNumber == sa.AllocationNumber
                                     && x.Period == sa.Period
                                     && x.SubnominalCode == SubnominalCodeToKeep
                                     && x.PaymentType == PaymentTypeReconciliation);

                    reconciliationSubnominalAggregationToKeep.PostedFlag = reconciliationSubnominalAggregationToDelete.PostedFlag;
                    reconciliationSubnominalAggregationToKeep.IsSelectedForPayment = reconciliationSubnominalAggregationToDelete.IsSelectedForPayment;

                    // remove PaaS SubnominalAggregation record for PaymentTypeReconciliation
                    dbContext.SubnominalAggregations.Remove(reconciliationSubnominalAggregationToDelete);
                }

                dbContext.SaveChanges();
            });
        }

        public void ApplySubnominalDataFixInCrm(XrmServiceContext xrmServiceContext)
        {
            SubnominalAggregations.ForEach(sa =>
            {
                string formattedPeriod = GetFormattedPeriod(sa.Period);
                string sfaSubnominalAggregateKeyToDelete = $"{SubnominalCodeToDelete}_{sa.AllocationNumber}_{formattedPeriod}";

                // get the capping SubnominalAggregation record to be deleted
                var subnominalAggregationCapping = xrmServiceContext.sfa_subnominalaggregationSet
                    .SingleOrDefault(x => x.sfa_SubnominalAggregateKey == sfaSubnominalAggregateKeyToDelete
                    && x.sfa_PaymentType.Value == (int)sfa_paymenttype.Capping);

                if (subnominalAggregationCapping != null)
                {
                    // remove capping SubnominalAggregation record
                    xrmServiceContext.DeleteObject(subnominalAggregationCapping);
                }

                // get the reconcilation SubnominalAggregation record to be deleted
                var subnominalAggregationReconciliation = xrmServiceContext.sfa_subnominalaggregationSet
                    .SingleOrDefault(x => x.sfa_SubnominalAggregateKey == sfaSubnominalAggregateKeyToDelete
                    && x.sfa_PaymentType.Value == (int)sfa_paymenttype.Reconciliation);

                if (subnominalAggregationReconciliation != null)
                {
                    // remove reconcilation SubnominalAggregation record
                    xrmServiceContext.DeleteObject(subnominalAggregationReconciliation);
                }

                xrmServiceContext.SaveChanges();
            });
        }

        public class SubnominalAggregationInfo
        {
            public string AllocationNumber { get; set; }

            public string Period { get; set; }
        }

        private static string GetFormattedPeriod(string period)
        {
            string[] months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
            string periodYear = period.Substring(2, 2);
            string periodMonth = months[(int.Parse(period.Substring(4)) - 1)];
            return $"{periodMonth}-{periodYear}";
        }
    }
}
