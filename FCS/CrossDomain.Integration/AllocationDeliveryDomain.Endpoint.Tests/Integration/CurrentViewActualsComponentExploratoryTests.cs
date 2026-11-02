namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.IO;
    using BusinessLogic;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using IoC;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Newtonsoft.Json;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.Framework.Logging.Bespoke;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;

    [TestClass]
    public class CurrentViewActualsComponentExploratoryTests
    {
        private ICurrentViewActualsComponent _currentViewActualsComponent;

        [TestInitialize]
        public void TestInitialize()
        {
            Mock<ILoggerFactory> loggerFactoryMock = new Mock<ILoggerFactory>();
            loggerFactoryMock.Setup(m => m.CreateLogger(It.IsAny<string>())).Returns(Mock.Of<ILogger>());

            IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(loggerFactoryMock.Object));
            container.Register(Component.For<IMonitoringDeliverablesDbContext>().ImplementedBy<MonitoringDeliverablesDbContext>().IsDefault());
            container.BeginScope();

            _currentViewActualsComponent = container.Resolve<ICurrentViewActualsComponent>();
        }

        [TestMethod, TestCategory("DataDependentExploratoryDOAT")]
        public void CurrentViewActualsComponent_ProcessActuals_ShouldCompleteInReasonableTimeWithEopAllocation()
        {
            Stopwatch stopwatch = new Stopwatch();
            List<EnrichedReportedActual> enrichedReportedActuals = GetEnrichedReportedActualsFromResource();

            stopwatch.Start();
            _currentViewActualsComponent.UpdateCurrentViewActualsReturningFullSetOfEnrichedActuals(enrichedReportedActuals);
            stopwatch.Stop();

            Assert.AreEqual(0, stopwatch.ElapsedMilliseconds);
        }

        private static List<EnrichedReportedActual> GetEnrichedReportedActualsFromResource()
        {
            using (TestResource testResource = new TestResource("AllocationDeliveryDomain.Endpoint.Tests.Resources", "ORG0001053-EOP1-E21-ValidActuals.json"))
            using (StreamReader streamReader = new StreamReader(testResource.Stream))
            {
                return JsonConvert.DeserializeObject<List<EnrichedReportedActual>>(streamReader.ReadToEnd());
            }
        }
    }
}
