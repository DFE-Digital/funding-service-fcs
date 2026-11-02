namespace PaymentManagement.Calculation.Tests.Integration
{
    using System.Configuration;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using Calculation.Repositories;
    using Calculation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Newtonsoft.Json;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;

    [TestClass]
    public class PaymentValuesCalculationServiceTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void PaymentValuesCalculationService_ShouldCreateZerosForCalculatedValues_When()
        {
            // arrange
            PaymentValuesCalculationService service = new PaymentValuesCalculationService(
                new PaymentValuesCalculator(
                    new PolicyFundingStreamPeriodRepository(),
                    new CensusDateService(new PaymentTimetableRepository(),new DateService(), new PolicyFundingStreamPeriodRepository()), 
                    new DeliverablePaymentRepository(),
                    Mock.Of<ILogger>(), new BehaviourFactory(new PolicyFundingStreamPeriodRepository())),
                new DeliverablePaymentRepository(),
                new CalculationInputActualEnrichmentService(
                    new DeliverablePaymentRepository(),
                    new AllocationQueryRepository()),

                new PolicyFundingStreamPeriodRepository(),
                Mock.Of<ILogger>(),
                Mock.Of<IFundingClaimReconciliationService>()
                );


            ConfigurationManager.AppSettings["UseRealDate"] = "false";
            var actualsMessage = GetVersionOneMessageFromFile();


            // act
            service.ProducePaymentScheduleOnActualsReceived(actualsMessage.AllocationActuals, ConnectionInfo.CreateFrom(new PaymentManagementPolicyContext().Database.Connection));
        }

        private IReadOnlyCollection<DeliverablePayment> GetDeliverablePayments(string allocationNumber, int version)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                return context.DeliverablePayments.Where(dp =>
                        dp.AllocationNumber == allocationNumber && dp.VersionNumber == version)
                    .ToList();
            }
        }

        private AllocationActualsVerified GetVersionOneMessageFromFile()
        {
            return FromJson<AllocationActualsVerified>("PaymentManagement.Calculation.Tests",
                "Resources.AllocationActualsVerified.json");
        }

        private static T FromJson<T>(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<T>(streamReader.ReadToEnd());
            }
        }
    }
}
