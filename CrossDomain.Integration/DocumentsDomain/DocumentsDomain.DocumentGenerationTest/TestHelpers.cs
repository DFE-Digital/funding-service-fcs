namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Xml.Serialization;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.DocumentsDomain.Common.Models;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentConfiguration;
    using SFA.FCT.DocumentsDomain.Integration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using DataStore;
    using DataStore.Repositories;
    using Framework.Logging.NullObjects;
    using PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.IoC;

    class TestHelpers
    {
        public static void TestDocumentPartCreatorSupply<T>(string templateName,
                                                            string masterContractXml,
                                                            params string[] documentGenerationRequestXml) where T : DocumentPartCreator
        {
            Contract contractObject = GetObjectFromXml<Contract>(masterContractXml);

            TestDocumentPartCreatorSupply<T>(templateName, null, contractObject, documentGenerationRequestXml);
        }

        public static void TestDocumentPartCreatorSupply<T>(string templateName,
                                                            IDocumentConfigurationSource configSource,
                                                            string masterContractXml,
                                                            params string[] documentGenerationRequestXml) where T : DocumentPartCreator
        {
            Contract contractObject = GetObjectFromXml<Contract>(masterContractXml);

            TestDocumentPartCreatorSupply<T>(templateName, configSource, contractObject, documentGenerationRequestXml);
        }

        public static void TestDocumentPartCreatorSupply<T>(string templateName,
                                                            IDocumentConfigurationSource configSource,
                                                            Contract masterContract,
                                                            params string[] documentGenerationRequestXml) where T : DocumentPartCreator
        {
            DocumentGenerationRequest[] docGens =
                documentGenerationRequestXml
                .Where(xml => xml.Length > 0)
                .Select(GetObjectFromXml<DocumentGenerationRequest>)
                .ToArray();

            TestDocumentPartCreatorSupply<T>(templateName, configSource, masterContract, docGens);
        }

        public static void TestDocumentPartCreatorSupply<T>(string templateName,
                                                            IDocumentConfigurationSource configSource,
                                                            Contract masterContract,
                                                            params DocumentGenerationRequest[] documentGenerationRequests) where T : DocumentPartCreator
        {
            Mock<ITemplateRepository> templateRepositoryMock = new Mock<ITemplateRepository>();
            templateRepositoryMock
                .Setup(m => m.GetNameOfTemplateActiveOnDate(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<DateTime>()))
                .Returns(templateName)
                .Verifiable();

            if (configSource == null)
                configSource = DocumentConfigurationSourceTests.GetDocumentConfigurationSourceWithMockRepositories();

            var container = CreateContainer();
            container.Register(
                Component.For<IDocumentConfigurationSource>().Instance(configSource).IsDefault().Named("OverridingConfigSource"), 
                Component.For<ITemplateRepository>().Instance(templateRepositoryMock.Object).IsDefault().Named("OverridingTemplateRepository"),
                Component.For<ILogger>().ImplementedBy<LoggerNullObject>().IsDefault().Named("OverrideLogger"));

            container.BeginScope();

            var partCreators = container.ResolveAll<DocumentPartCreator>();

            T classUnderTest = (T) partCreators.Single(p => p.GetType() == typeof (T));

            IDictionary<string, DocumentGenerationRequest> response = classUnderTest.SupplyDocumentGenerationRequest(masterContract.contractNumber, masterContract.contracts.First(), "document-template-dev");
            DocumentGenerationRequest[] responseInOrder = response.OrderBy(k => k.Key).Select(v => v.Value).ToArray();

            Assert.AreEqual(documentGenerationRequests.Count(), response.Count, "The number of DocumentGenerationRequests created is incorrect ");
            for (int i=0; i<response.Count; i++)
            {
                Assert.IsTrue(AreObjectsEquivelant(documentGenerationRequests[i], responseInOrder[i]));
            }            
        }

        public static void TestDocumentPartCreatorSupply<T>(string templateName,
                                                           Contract masterContract,
                                                           params DocumentGenerationRequest[] documentGenerationRequests) where T : DocumentPartCreator
        {
            IAzureStorageWrapper storageWrapper = new AzureStorageWrapper();
            ITemplateRepository templateRepository = new TemplateRepository(storageWrapper);

            Mock<IFundingTypeFundingPeriodQueryRepository> mockFspRepository = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            mockFspRepository.Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>()))
                             .Returns(new FundingTypeFundingPeriod {TemplateName = templateName});

            var documentDomainDbContext = new DocumentsDomainDbContext();
            var configSource = new DocumentConfigurationSource(
                new FundingStreamPeriodRepository(documentDomainDbContext),
                new FspDeliverableRepository(documentDomainDbContext),
                new FundingTypeFundingPeriodRepository(documentDomainDbContext));

            var container = CreateContainer();
            container.Register(
                Component.For<IDocumentConfigurationSource>().Instance(configSource).IsDefault().Named("OverridingConfigSource"),
                Component.For<ITemplateRepository>().Instance(templateRepository).IsDefault().Named("OverridingTemplateRepository"),
                Component.For<IContractManagementDbContext>().ImplementedBy<ContractManagementDbContext>().IsDefault().Named("OverrideCmDbContext"),
                Component.For<IPaymentManagementPolicyContext>().ImplementedBy<PaymentManagementPolicyContext>().LifestyleScoped().IsDefault().Named("OverridePmPolicyContext"),
                Component.For<DocumentsDomainDbContext>().ImplementedBy<DocumentsDomainDbContext>().LifestyleScoped().IsDefault(),
                Component.For<IFundingTypeFundingPeriodQueryRepository>().Instance(mockFspRepository.Object).LifestyleScoped().IsDefault().Named("OverrideFtFpRepository"),
                Component.For<ILogger>().ImplementedBy<LoggerNullObject>().IsDefault().Named("OverrideLogger"));

            container.BeginScope();

            var partCreators = container.ResolveAll<DocumentPartCreator>();

            T classUnderTest = (T)partCreators.Single(p => p.GetType() == typeof(T));

            IDictionary<string, DocumentGenerationRequest> response = classUnderTest.SupplyDocumentGenerationRequest(masterContract.contractNumber, masterContract.contracts.First(), ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"]);
            DocumentGenerationRequest[] responseInOrder = response.OrderBy(k => k.Key).Select(v => v.Value).ToArray();

            Assert.AreEqual(documentGenerationRequests.Count(), response.Count, "The number of DocumentGenerationRequests created is incorrect ");
            for (int i = 0; i < response.Count; i++)
            {
                Assert.IsTrue(AreObjectsEquivelant(documentGenerationRequests[i], responseInOrder[i]));
            }
        }

        private static IWindsorContainer CreateContainer()
        {
            return WindsorInstallerForDocumentGenerator.Container;
        }

        public static void TestDocumentHeaderCreatorSupply<T>(string templateName, string masterContractXml, string documentGenerationRequestXml) where T : IDocumentHeaderCreator
        {
            Contract masterContract = GetObjectFromXml<Contract>(masterContractXml);
            DocumentGenerationRequest docGen = GetObjectFromXml<DocumentGenerationRequest>(documentGenerationRequestXml);

            Mock<ITemplateRepository> templateRepositoryMock = new Mock<ITemplateRepository>();
            templateRepositoryMock
                .Setup(m => m.GetNameOfTemplateActiveOnDate(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<DateTime>()))
                .Returns(templateName)
                .Verifiable();

            T classUnderTest = (T)Activator.CreateInstance(typeof(T), templateRepositoryMock.Object);

            Tuple<string, DocumentGenerationRequest> response = classUnderTest.SupplyDocumentGenerationRequest("SFA-1234", masterContract, "document-template-dev");
            Assert.IsNotNull(response.Item2);
            Assert.IsTrue(AreObjectsEquivelant<DocumentGenerationRequest>(docGen, response.Item2));
        }

        public static T GetObjectFromXml<T>(string xml) where T : class
        {
            T objectToReturn = null;
            using (MemoryStream inputStream = new MemoryStream())
            {
                StreamWriter writer = new StreamWriter(inputStream);
                writer.Write(xml);
                writer.Flush();
                inputStream.Position = 0;
                objectToReturn = new XmlSerializer(typeof(T)).Deserialize(inputStream) as T;
            }
            return objectToReturn;
        }

        private static bool AreObjectsEquivelant<T>(T obj1, T obj2) where T : class
        {
            string obj1Xml = GetXmlFromObject<T>(obj1).Replace("\n", "").Replace("\r", "");
            string obj2Xml = GetXmlFromObject<T>(obj2).Replace("\n", "").Replace("\r", "");

            return obj1Xml == obj2Xml;
        }

        private static string GetXmlFromObject<T>(T obj) where T : class
        {
            string objXml;

            using (MemoryStream outputStream = new MemoryStream())
            {
                XmlSerializer xs = new XmlSerializer(typeof(T));
                xs.Serialize(outputStream, obj);
                outputStream.Flush();
                outputStream.Position = 0;
                StreamReader sr = new StreamReader(outputStream);
                objXml = sr.ReadToEnd();
            }

            return objXml;
        }
       
        public static void TestIsHeaderRequired<T>(bool value) where T:DocumentPartCreator
        {
            PropertyInfo isHeaderDocumentRequiredPropertyInfo = typeof (T).GetProperty("IsHeaderDocumentRequired");
            Assert.IsNotNull(isHeaderDocumentRequiredPropertyInfo);
            MethodInfo getIsHeaderDocumentRequired = isHeaderDocumentRequiredPropertyInfo.GetGetMethod();
            Assert.IsNotNull(getIsHeaderDocumentRequired);

            T creator = (T)Activator.CreateInstance(typeof (T), new object[]{null, null});
            Assert.AreEqual(getIsHeaderDocumentRequired.Invoke(creator, new object[0]), value);
        }


        public static Mock<IAzureStorageWrapper> GetAzureStorageMock()
        {
            Mock<IAzureStorageWrapper> mock = new Mock<IAzureStorageWrapper>();
            mock
                .Setup(m=>m.GetContainerContents(It.IsAny<string>()))
                .Returns(new string[]
                {
                    "A1_24+_1516_2015-08-01.docx",
                    "A1_AGE_1516_2015-04-01.docx",
                    "A1_ESF_1420_2014-08-01.docx",
                    "A1_MAIN_1516_2015-08-01.docx",
                    "A2_24+ALLB1516_2015-08-01.docx",
                    "A2_AGE1516_2015-04-01.docx",
                    "A2_ASC1516_2015-08-01.docx",
                    "A2_CL1516_2015-08-01.docx",
                    "A2_DLS1516_2015-08-01.docx",
                    "A2_OLASS1516_2015-08-01.docx",
                    "A2H_24+LOANS_2015-08-01.docx",
                    "A2H_AGE_2015-04-01.docx",
                    "A2H_ESF_2015-08-01.docx",
                    "A2H_MAIN_2015-08-01.docx",
                    "A2_16-18APPS1516_2015-08-01.docx",
                    "A2_ESF201420_2015-04-01.docx"
                })
                .Verifiable();

            return mock;
        }

        public static Mock<ITemplateRepository> GetTemplateRepositoryMock()
        {
            Mock<ITemplateRepository> mock = new Mock<ITemplateRepository>();
            mock
                .Setup(m => m.GetTemplateNames(It.IsAny<string>()))
                .Returns(new string[]
                {
                    "A1_24+_1516_2015-08-01.docx",
                    "A1_AGE_1516_2015-04-01.docx",
                    "A1_ESF_1420_2014-08-01.docx",
                    "A1_MAIN_1516_2015-08-01.docx",
                    "A2_24+ALLB1516_2015-08-01.docx",
                    "A2_AGE1516_2015-04-01.docx",
                    "A2_ASC1516_2015-08-01.docx",
                    "A2_CL1516_2015-08-01.docx",
                    "A2_DLS1516_2015-08-01.docx",
                    "A2_OLASS1516_2015-08-01.docx",
                    "A2H_24+LOANS_2015-08-01.docx",
                    "A2H_AGE_2015-04-01.docx",
                    "A2H_ESF_2015-08-01.docx",
                    "A2H_MAIN_2015-08-01.docx",
                    "A2_ESF201420_2015-04-01.docx"
                })
                .Verifiable();

            return mock;
        }
    }
}
