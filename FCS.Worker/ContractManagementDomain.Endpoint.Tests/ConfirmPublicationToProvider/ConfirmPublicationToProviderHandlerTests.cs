namespace ContractManagementDomain.Endpoint.Tests.ConfirmPublicationToProvider
{
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.ConfirmPublicationToProvider;
    using Endpoint.Services;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractApproval;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ConfirmPublicationToProviderHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ConfirmPublicationToProviderHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ConfirmPublicationToProviderHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<ConfirmPublicationToProviderHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ConfirmPublicationToProviderHandler_GetCorporateContractReturnsContract_SendsMessageOnBus()
        {
            // arrange
            const string testFundingTypeCode = "ESF",
                testFundingTypeName = "EUROPEANSOCIALFUND",
                testContractNo = "1",
                testMasterConNo = "11";


            string completePeriod = periodTypeCodeType.AY + "1516";

            Contract corpContract = new Contract
            {
                contractNumber = testMasterConNo,
                contracts =
                {
                    new Contract
                    {
                        contractNumber = testContractNo,
                        fundingType = new fundingType {fundingTypeCode = testFundingTypeCode, fundingTypeName = testFundingTypeName},
                        period = new Period {period1 = "1516",periodType = new periodTypeType {periodTypeName = periodTypeNameType.ACADEMICYEAR, periodTypeCode = periodTypeCodeType.AY} },
                        DocumentationRequired = true
                    }
                }
            };

            Mock<IContractsManager> contractsManagerMock = new Mock<IContractsManager>();
            contractsManagerMock
                .Setup(x => x.GetCorporateContract(testContractNo, testMasterConNo, false))
                .Returns(corpContract);

            Mock<IFundingTypeFundingPeriodService> fundingTypeFundingPeriodServiceMock = new Mock<IFundingTypeFundingPeriodService>();
            fundingTypeFundingPeriodServiceMock
                .Setup(s => s.GetApprovalType(testFundingTypeCode, completePeriod))
                .Returns(ContractApprovalType.Electronic);
            
            ConfirmPublicationToProviderCommand testMessage = new ConfirmPublicationToProviderCommand
            {
                ContractNumber = testContractNo,
                MasterContractNumber = testMasterConNo
            };

            ConfirmPublicationToProviderHandler handler = new ConfirmPublicationToProviderHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<IDateProvider>(),
                contractsManagerMock.Object,
                fundingTypeFundingPeriodServiceMock.Object,
                Mock.Of<IXrmManager>());

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(testMessage, context).Wait();

            // assert
            Assert.AreEqual(1, context.SentMessages
                .Select(m => m.Message)
                .OfType<DocumentMoveCommand>()
                .Count(d => d.CorporateContract.contractNumber == corpContract.contractNumber && d.ContractApprovalType == ContractApprovalType.Electronic));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ConfirmPublicationToProviderHandler_ShouldUpdateCrmWhenContractActivityCloseDateExeeded()
        {
            // arrange
            ConfirmPublicationToProviderCommand testMessage = new ConfirmPublicationToProviderCommand
            {
                ContractNumber = "1",
                MasterContractNumber = "1"
            };

            Contract simpleContract = CreateSimpleCorpContract();
            Contract simpleChildContract = CreateSimpleCorpContract();
            simpleChildContract.contractNumber = "1";
            simpleContract.contracts.Add(simpleChildContract);

            Mock<IContractsManager> contractsManagerMock = new Mock<IContractsManager>();
            contractsManagerMock
                .Setup(x => x.GetCorporateContract(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<bool>()))
                .Returns(simpleContract);

            Mock<IFundingTypeFundingPeriodService> fundingTypeFundingPeriodServiceMock = new Mock<IFundingTypeFundingPeriodService>();
            fundingTypeFundingPeriodServiceMock
                .Setup(s => s.IsProcessDateAfterFundingTypeContractingActivityCloseDate(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(true);

            Mock<IXrmManager> xrmManagerMock = new Mock<IXrmManager>();

            ConfirmPublicationToProviderHandler handler = new ConfirmPublicationToProviderHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<IDateProvider>(),
                contractsManagerMock.Object,
                fundingTypeFundingPeriodServiceMock.Object,
                xrmManagerMock.Object);

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(testMessage, context).Wait();

            // assert
            xrmManagerMock.Verify(
                x => x.UpdateContractPublishedToProviderFailed(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string>()),
                Times.Once);
        }

        private static Contract CreateSimpleCorpContract()
        {
            return new Contract
            {
                fundingType = new fundingType
                {
                    fundingTypeCode = "AGE"
                },
                period = new Period
                {
                    periodType = new periodTypeType
                    {
                        periodTypeCode = periodTypeCodeType.FY
                    },
                    period1 = "1516"
                }
            };
        }
    }
}
