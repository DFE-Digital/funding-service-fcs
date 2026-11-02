namespace FCT.Operations.Common.Tests.Tools
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.Common.Commands;
    using SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint.Handlers;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Repositories;
    using SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint.Services;
    using CorporateSchema = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.CorporateSchema._3_0;

    [TestClass]
    public class FundingClaimsCollectionRetrievalTools
    {
        private static readonly DateTime LastCompletedImportDate = new DateTime(2019, 06, 06, 00, 00, 00, DateTimeKind.Utc);

        private List<ClosedFundingClaimCollectionCommand> _generatedClosedCollectionEventCommands;
        private List<FundingClaimPagedRequestCommand> _generatedPageRequestCommands;
        private List<FundingClaimInfo> _retrievedFundingClaims; 
        private FundingClaimsPoller _fundingClaimsPoller;

        [TestInitialize]
        public void TestInitialize()
        {
            _generatedClosedCollectionEventCommands = new List<ClosedFundingClaimCollectionCommand>();
            _generatedPageRequestCommands = new List<FundingClaimPagedRequestCommand>();
            _retrievedFundingClaims = new List<FundingClaimInfo>();

            //busMock
            //    .Setup(m => m.Send(It.IsAny<ClosedFundingClaimCollectionCommand>()))
            //    .Callback<object>(command => _generatedClosedCollectionEventCommands.Add((ClosedFundingClaimCollectionCommand)command));
            //busMock
            //    .Setup(m => m.Send(It.IsAny<FundingClaimPagedRequestCommand>()))
            //    .Callback<object>(command => _generatedPageRequestCommands.Add((FundingClaimPagedRequestCommand)command));

            //var claimReconciliationBehaviourRepositoryMock = new Mock<IClaimReconciliationBehaviourRepository>();
            //claimReconciliationBehaviourRepositoryMock
            //    .Setup(m => m.DoesClaimCollectionCodeExist(It.IsAny<string>()))
            //    .Returns(true);

            //_fundingClaimsPoller = new FundingClaimsPoller(
            //    busMock.Object,
            //    Mock.Of<ILogger>(),
            //    new TestFundingClaimRepository(), 
            //    new TestFundingClaimDedsService(
            //        new FundingClaimDedsService(new DedsSearchProxyServiceChannelFactory()),
            //        (collectionType, fundingClaimName, xml) =>
            //        {
            //            _retrievedFundingClaims.Add(new FundingClaimInfo(collectionType, fundingClaimName, xml));
            //        }),
            //    new TestFundingClaimCollectionImportInfoRepository(LastCompletedImportDate), 
            //    claimReconciliationBehaviourRepositoryMock.Object,
            //    Mock.Of<IDate>(),
            //    Mock.Of<IFundingClaimAllocationFilter>());
        }

        [TestMethod]
        public void RetrieveFundingClaimsCollectionsFromDedsServiceIntoXml()
        {
            //_fundingClaimsPoller.Handle(new InitiateFundingClaimImportCommand());
            //Assert.IsTrue(_generatedClosedCollectionEventCommands.Any(), "No ClosedFundingClaimCollectionCommand messages generated.");

            //_generatedClosedCollectionEventCommands.ForEach(cmd => _fundingClaimsPoller.Handle(cmd));
            //Assert.IsTrue(_generatedPageRequestCommands.Any(), "No FundingClaimPagedRequestCommand messages generated.");

            //_generatedPageRequestCommands.ForEach(cmd => _fundingClaimsPoller.Handle(cmd));
            //Assert.IsTrue(_retrievedFundingClaims.Any(), "No Funding Claims retrieved.");

            //string folderName = DateTime.Now.ToString("yyyy-MM-dd HH-mm-ss");

            //_retrievedFundingClaims.ForEach(fc => WriteFileToDisk(folderName, fc));
        }

        private static void WriteFileToDisk(string folderName, FundingClaimInfo fundingClaim)
        {
            FileInfo fileInfo = new FileInfo($"{folderName}\\{fundingClaim.CollectionType}\\{fundingClaim.FundingClaimName}.xml");
            fileInfo.Directory.Create();
            File.WriteAllText(fileInfo.FullName, fundingClaim.FundingClaimXml);
        }

        private class TestFundingClaimCollectionImportInfoRepository : IFundingClaimCollectionImportInfoRepository
        {
            private readonly DateTime _lastCompletedImportDate;
            private readonly Dictionary<string, FundingClaimCollectionImportInfo> _fundingClaimCollections = new Dictionary<string, FundingClaimCollectionImportInfo>();  

            public TestFundingClaimCollectionImportInfoRepository(DateTime lastCompletedImportDate)
            {
                _lastCompletedImportDate = lastCompletedImportDate;
            }

            public DateTime? GetLastCompletedImportDate()
            {
                return _lastCompletedImportDate;
            }

            public void AddRowOrUpdate(FundingClaimCollectionImportInfo fundingClaimCollectionImportInfo)
            {
                _fundingClaimCollections[fundingClaimCollectionImportInfo.PeriodClaimType] = fundingClaimCollectionImportInfo;
            }

            public FundingClaimCollectionImportInfo Find(string periodClaimType)
            {
                return _fundingClaimCollections[periodClaimType];
            }
        }

        private class TestFundingClaimDedsService : IFundingClaimDedsService
        {
            private readonly FundingClaimDedsService _fundingClaimDedsService;
            private readonly Action<string, string, string> _onFundingClaimRetrieved;

            public TestFundingClaimDedsService(FundingClaimDedsService fundingClaimDedsService, Action<string, string, string> onFundingClaimRetrieved)
            {
                _fundingClaimDedsService = fundingClaimDedsService;
                _onFundingClaimRetrieved = onFundingClaimRetrieved;
            }

            public Guid GetLatestPublishedDataSetVersionId()
            {
                return _fundingClaimDedsService.GetLatestPublishedDataSetVersionId();
            }

            public IEnumerable<string> GetFundingClaimCompletedCollections(Guid dataSetVersionId, DateTime dateTime)
            {
                return _fundingClaimDedsService.GetFundingClaimCompletedCollections(dataSetVersionId, dateTime);
            }

            public IEnumerable<string> GetFundingClaimsThatAreCompleted(Guid dataSetVersionId, string dataCollectionKey, int? pageSize, int? pageNumber)
            {
                List<string> fundingClaims = _fundingClaimDedsService.GetFundingClaimsThatAreCompleted(dataSetVersionId, dataCollectionKey, pageSize, pageNumber).ToList();

                fundingClaims.ForEach(xml =>
                {
                    CorporateSchema.FundingClaim corporateFundingClaim = xml.DeserializeXml<CorporateSchema.FundingClaim>();
                    string fundingClaimKey = $"{corporateFundingClaim.FundingClaimAllAttrs.First().FundingClaimPKeyAttrs.Contractor.ContractorNonPKeyAttrs.Ukprn}";
                    _onFundingClaimRetrieved(dataCollectionKey, fundingClaimKey, xml);
                });

                return fundingClaims;
            }

            public int GetFundingClaimsThatAreCompletedCount(Guid dataSetVersionId, string dataCollectionKey)
            {
                return _fundingClaimDedsService.GetFundingClaimsThatAreCompletedCount(dataSetVersionId, dataCollectionKey);
            }
        }

        private class TestFundingClaimRepository : IFundingClaimRepository
        {
            private readonly List<FundingClaim> _fundingClaims = new List<FundingClaim>();

            public SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.FundingClaim GetFundingClaimByNaturalKey(FundingClaimNaturalKey naturalKey)
            {
                throw new NotImplementedException();
            }

            public List<SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.FundingClaim> RetrieveAllFundingClaimsForPeriodAndClaimType(string period, string claimTypeName)
            {
                throw new NotImplementedException();
            }

            public void AddFundingClaims(List<FundingClaim> dataStoreFundingClaims)
            {
                _fundingClaims.AddRange(dataStoreFundingClaims);
            }

            public int GetCountOfFundingClaimsForCollection(string period, string claimTypeName)
            {
                return _fundingClaims.Count;
            }
        }

        private class FundingClaimInfo
        {
            public FundingClaimInfo(string collectionType, string fundingClaimName, string fundingClaimXml)
            {
                CollectionType = collectionType;
                FundingClaimName = fundingClaimName;
                FundingClaimXml = fundingClaimXml;
            }

            public string CollectionType { get; }

            public string FundingClaimName { get; }

            public string FundingClaimXml { get; }
        }
    }
}
