namespace ContractCreateDomain.Integration.XrmService.Tests.DataFix
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;

    [TestClass]
    public class DeleteDeliverablePeriodsPriorToEsfAllocationStartDateDataFix
    {
        private bool ShouldDeleteEntities = false;
        private const string CrmConnectionString = @"Url=https://fcs-pp-crmw.preprod.fcs.sfa.bis.gov.uk/skillsfundingagency; Username=fcspreprod\CRMIntegration; Password=";
        private const string PaasConnectionString = "";
        private IOrganizationService _organizationService;

        [TestInitialize]
        public void TestInitialize()
        {
            _organizationService = new OrganizationService(CrmConnection.Parse(CrmConnectionString));
        }

        [TestMethod, TestCategory("DataFix_R15b")]
        public void DeleteDeliverablePeriodsPriorToAllocationStartDateDataFix()
        {
            const string fspCode = "ESF1420";

            List<DeliverablePeriodInfo> invalidDeliverablePeriods =
                GetAllAllocationDeliverablePeriodsForFundingStreamPeriod(fspCode)
                .Where(dp => dp.Period < dp.AllocationStartPeriod)
                .ToList();

            Assert.AreEqual(9, invalidDeliverablePeriods.Count);

            WriteQueryResultsToCsv(invalidDeliverablePeriods);

            invalidDeliverablePeriods.ForEach(DeleteDeliverablePeriodFromSql);
            invalidDeliverablePeriods.ForEach(DeleteDeliverablePeriodFromCrm);
        }

        private void DeleteDeliverablePeriodFromCrm(DeliverablePeriodInfo deliverablePeriod)
        {
            if (ShouldDeleteEntities)
            {
                _organizationService.Delete("sfa_contractdeliverableperiod", deliverablePeriod.Id);
            }
        }

        private void DeleteDeliverablePeriodFromSql(DeliverablePeriodInfo deliverablePeriod)
        {
            using (PaymentSchedulePolicyContext context = new PaymentSchedulePolicyContext())
            {
                context.Database.Connection.ConnectionString = PaasConnectionString;

                DeliverablePayment deliverablePayment = context.DeliverablePayments.SingleOrDefault(dp =>
                    dp.AllocationNumber == deliverablePeriod.AllocationNumber
                    && dp.VersionNumber == deliverablePeriod.AllocationVersion
                    && dp.DeliverableCode == deliverablePeriod.DeliverableCode
                    && dp.Period == deliverablePeriod.Period.ToString());

                Assert.IsNotNull(deliverablePayment);

                if (ShouldDeleteEntities)
                {
                    if (deliverablePayment != null)
                    {
                        context.DeliverablePayments.Remove(deliverablePayment);
                        context.SaveChanges();
                    }
                }
            }
        }

        private IList<DeliverablePeriodInfo> GetAllAllocationDeliverablePeriodsForFundingStreamPeriod(string fspCode)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(_organizationService))
            {
                return (from cdp in xrmContext.sfa_contractdeliverableperiodSet
                        join pt in xrmContext.sfa_periodtypeSet on cdp.sfa_PeriodTypeId.Id equals pt.sfa_periodtypeId
                        join d in xrmContext.sfa_contractdeliverableSet on cdp.sfa_ContractDeliverableId.Id equals d.Id
                        join a in xrmContext.sfa_contractallocationSet on d.sfa_ContractAllocationId.Id equals a.sfa_contractallocationId
                        join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                        join fsp in xrmContext.sfa_fundingstreamperiodSet on a.sfa_FundingStreamPeriodId.Id equals fsp.sfa_fundingstreamperiodId
                        where fsp.sfa_fundingstreamperiodcode == fspCode
                            //&& a.sfa_contractallocationnumber == "ESF-2096"
                        select new DeliverablePeriodInfo
                        {
                            Id = cdp.Id,
                            AllocationNumber = a.sfa_contractallocationnumber,
                            AllocationVersion = c.sfa_Version.GetValueOrDefault(),
                            AllocationStartPeriod = FormatPeriod(a.sfa_startdate.GetValueOrDefault().Year, a.sfa_startdate.GetValueOrDefault().Month),
                            DeliverableCode = int.Parse(d.sfa_DeliverableCode),
                            Period = FormatPeriod(cdp.sfa_Year.GetValueOrDefault(), cdp.sfa_Period.GetValueOrDefault())
                        })
                        .ToList();
            }
        }

        private static int FormatPeriod(int year, int month)
        {
            return int.Parse($"{year.ToString("D4")}{month.ToString("D2")}");
        }

        private static void WriteQueryResultsToCsv(IEnumerable<DeliverablePeriodInfo> deliverablePeriods)
        {
            List<string> csv = new List<string>
            {
                "AllocationNumber,VersionNumber,DeliverableCode,Period"
            };

            csv.AddRange(deliverablePeriods
                .OrderBy(dp => dp.AllocationNumber)
                .ThenBy(dp => dp.AllocationVersion)
                .ThenBy(dp => dp.DeliverableCode)
                .ThenBy(dp => dp.Period)
                .Select(dp => $"{dp.AllocationNumber},{dp.AllocationVersion},{dp.DeliverableCode},{dp.Period}"));

            System.IO.File.WriteAllLines($"DeliverablePeriodsPriorToAllocationStartDate-{DateTime.Now.ToString("yyyy-MM-dd HH-mm-ss")}.csv", csv);
        }

        public class DeliverablePeriodInfo
        {
            public Guid Id { get; set; }

            public string AllocationNumber { get; set; }

            public long AllocationVersion { get; set; }

            public int AllocationStartPeriod { get; set; }

            public int DeliverableCode { get; set; }

            public int Period { get; set; }
        }
    }
}
