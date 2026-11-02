namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentDefiner;
    using DocumentDefiner.DocumentPartCreators.Appendix1;
    using Framework.Logging.Interfaces;
    using Framework.Logging.NullObjects;
    using IoC;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass]
    public class DocumentPartFinderTests
    {
        private Mock<ILoggerFactory> _loggerFactory;

        [TestInitialize]
        public void Initialize()
        {
            _loggerFactory = new Mock<ILoggerFactory>();
            _loggerFactory
                .Setup(m => m.CreateLogger(It.IsAny<string>()))
                .Returns(new LoggerNullObject());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentPartFinder_ShouldReturnOnyEdskSummaryOfFundingDocumentPartCreator_When_NonFinancialForEDSK_1920()
        {
            using (var container = new WindsorContainer())
            {
                container.Install(new IWindsorInstaller[]
                {
                    new SFA.FCT.DocumentsDomain.DocumentGeneration.IoC.WindsorInstallerForDocumentGenerator(_loggerFactory.Object)
                });

                container.BeginScope();

                IDocumentPartFinder finder = new DocumentPartFinder();

                contractType contractType = new contractType
                {
                    IsNonFinancialAmendment = true,
                    fundingType = new fundingType
                    {
                        fundingTypeCode = "EDSK"
                    },
                    period = new period
                    {
                        period1 = "1920"
                    }
                };

                DocumentPartCreator[] creators = finder.GetDocumentPartCreators(contractType);

                Assert.AreEqual(1, creators.Length, "We should only create on DocumentPartCreator");
                Assert.IsTrue(creators.First() is EdskSummaryOfFundingDocumentPartCreator, "The type of the DocumentPartCreator is wrong");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentPartFinder_ShouldReturnOnyEdskSummaryOfFundingDocumentPartCreator_When_NonFinancialForEDSK_2021_AndNotification()
        {
            using (var container = new WindsorContainer())
            {
                container.Install(new IWindsorInstaller[]
                {
                    new WindsorInstallerForDocumentGenerator(_loggerFactory.Object)
                });

                container.BeginScope();

                IDocumentPartFinder finder = new DocumentPartFinder();

                contractType contractType = new contractType
                {
                    IsNonFinancialAmendment = true,
                    fundingType = new fundingType
                    {
                        fundingTypeCode = "EDSK"
                    },
                    period = new period
                    {
                        period1 = "2021"
                    },
                    IsVariation = false // notification
                };

                DocumentPartCreator[] creators = finder.GetDocumentPartCreators(contractType);

                Assert.AreEqual(1, creators.Length, "We should only create on DocumentPartCreator");
                Assert.IsTrue(creators.First() is EdskSummaryOfFundingDocumentPartCreator, "The type of the DocumentPartCreator is wrong");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentPartFinder_ShouldReturnAllDocumentPartCreators_When_NonFinancialForAEB_2021_AndNotification()
        {
            using (var container = new WindsorContainer())
            {
                container.Install(new IWindsorInstaller[]
                {
                    new WindsorInstallerForDocumentGenerator(_loggerFactory.Object)
                });

                container.BeginScope();

                IDocumentPartFinder finder = new DocumentPartFinder();

                contractType contractType = new contractType
                {
                    IsNonFinancialAmendment = true,
                    fundingType = new fundingType
                    {
                        fundingTypeCode = "AEB2021"
                    },
                    period = new period
                    {
                        period1 = "ANY"
                    },
                    IsVariation = false // notification
                };

                DocumentPartCreator[] creators = finder.GetDocumentPartCreators(contractType);

                Assert.IsTrue(creators.Length > 1, "We want all");
            }
        }


        [TestMethod, TestCategory("UnitTest")]
        public void DocumentPartFinder_ShouldReturnAllDocumentPartCreators_When_NonFinancialForAEB_2023_AndNotification()
        {
            using (var container = new WindsorContainer())
            {
                container.Install(new IWindsorInstaller[]
                {
                    new WindsorInstallerForDocumentGenerator(_loggerFactory.Object)
                });

                container.BeginScope();

                IDocumentPartFinder finder = new DocumentPartFinder();

                contractType contractType = new contractType
                {
                    IsNonFinancialAmendment = true,
                    fundingType = new fundingType
                    {
                        fundingTypeCode = "AEB2023"
                    },
                    period = new period
                    {
                        period1 = "ANY"
                    },
                    IsVariation = false // notification
                };

                DocumentPartCreator[] creators = finder.GetDocumentPartCreators(contractType);

                Assert.IsTrue(creators.Length > 1, "We want all");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentPartFinder_ShouldReturnLots_When_NonFinancialForEDSK_2021_AndVariation()
        {
            using (var container = new WindsorContainer())
            {
                container.Install(new IWindsorInstaller[]
                {
                    new WindsorInstallerForDocumentGenerator(_loggerFactory.Object)
                });

                container.BeginScope();

                IDocumentPartFinder finder = new DocumentPartFinder();

                contractType contractType = new contractType
                {
                    IsNonFinancialAmendment = true,
                    fundingType = new fundingType
                    {
                        fundingTypeCode = "EDSK"
                    },
                    period = new period
                    {
                        period1 = "2021"
                    },
                    IsVariation = true
                };

                DocumentPartCreator[] creators = finder.GetDocumentPartCreators(contractType);

                Assert.IsTrue(creators.Length > 1, "We should create many DocumentPartCreators");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentPartFinder_ShouldReturnTheRightNumberOfDocumentPartCreators_When_NotNonFinancial()
        {
            using (var container = new WindsorContainer())
            {
                container.Install(new IWindsorInstaller[]
                {
                    new WindsorInstallerForDocumentGenerator(_loggerFactory.Object)
                });

                container.BeginScope();

                IDocumentPartFinder finder = new DocumentPartFinder();

                contractType contractType = new contractType
                {
                    IsNonFinancialAmendment = null,
                    fundingType = new fundingType
                    {
                        fundingTypeCode = "EDSK"
                    }
                };

                DocumentPartCreator[] creators = finder.GetDocumentPartCreators(contractType);

                Assert.AreEqual(19, creators.Length, "We have not created the right number of DocumentPartCreators");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestThatGetDocumentHeaderCreatorsReturnsAtLeastOneInstance()
        {
            using (var container = new WindsorContainer())
            {
                container.Install(new IWindsorInstaller[]
                {
                    new WindsorInstallerForDocumentGenerator(_loggerFactory.Object)
                });

                IDocumentPartFinder finder = new DocumentPartFinder();

                IDocumentHeaderCreator[] creators = finder.GetDocumentHeaderCreators();

                Assert.IsTrue(creators.Length > 0);
            }

        }
    }
}
