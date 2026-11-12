namespace Datafix.Tests
{
    using System.Linq;
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Text;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using NServiceBus;
    using Repositories;
    using Services;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using ContractInformation = SFA.FCT.CrossDomain.Integration.Entities.ContractInformation;
    using SFA.FCT.ContractManagementService.Common.Commands;

    [TestClass]
    public class AmendAllLevyContractsDatafix
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AmendAllLevyContracts()
        {
            const string levyFundingType = "LEVY";
            const string levyFundingPeriod = "LEVY1799";

            CrmContractInformationRepository crmRepository = new CrmContractInformationRepository();
            LevyAmendmentLogger logger = new LevyAmendmentLogger();
            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<AmendLevyContractCommand>();

            logger.Log("INFORMATION: Retrieving all LEVY contracts from CRM");

            try
            {
                IReadOnlyCollection<ContractInformation> levyContracts =
                    crmRepository.GetLatestContractInformationByFundingTypeAndFundingPeriod(levyFundingType, levyFundingPeriod);

                logger.Log($"INFORMATION: Found {levyContracts.Count} LEVY contracts, beginning processing");

                levyContracts.ForEach(contract =>
                {
                    logger.Log($"INFORMATION: Sending AmendLevyContractCommand for {contract}");

                    endpoint.Send("ContractManagementDomain.LevyAmendmentEndpoint", new AmendLevyContractCommand
                    {
                        ContractInformation = contract
                    }).Wait();
                });
            }
            catch (Exception ex)
            {
                logger.Log($"ERROR: An exception occurred: {ex.Message}");
            }
            finally
            {
                logger.SaveLogToDisk();
            }
        }

        public static void AmendAllLevyContractsThatMeetCriteria(Func<ContractInformation, bool> predicate)
        {
            const string levyFundingType = "LEVY";
            const string levyFundingPeriod = "LEVY1799";

            CrmContractInformationRepository crmRepository = new CrmContractInformationRepository();
            
            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<AmendLevyContractCommand>();

            IReadOnlyCollection<ContractInformation> levyContracts =
                crmRepository.GetLatestContractInformationByFundingTypeAndFundingPeriod(levyFundingType, levyFundingPeriod)
                    .Where(predicate).ToList();

            levyContracts.ForEach(contract =>
            {
                endpoint.Send("ContractManagementDomain.LevyAmendmentEndpoint", new AmendLevyContractCommand
                {
                    ContractInformation = contract
                }).Wait();
            });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AmendAllLevyContractsOnList()
        {
            const string levyFundingType = "LEVY";
            const string levyFundingPeriod = "LEVY1799";

            IReadOnlyCollection<string> ukprns = new List<string>
            {
                "10000028",
                "10000061",
                "10000285",
                "10000715",
                "10001282",
                "10001515",
                "10002143",
                "10003026",
                "10003347",
                "10003382",
                "10003385",
                "10003526",
                "10003571",
                "10004856",
                "10005204",
                "10005250",
                "10005457",
                "10005642",
                "10006574",
                "10006600",
                "10007151",
                "10007315",
                "10019276",
                "10019581",
                "10021755",
                "10023776",
                "10026590",
                "10027438",
                "10029736",
                "10034940",
                "10035171",
                "10038020",
                "10040664",
                "10044321",
                "10048217",
                "10006963"
            };

            CrmContractInformationRepository crmRepository = new CrmContractInformationRepository();
            LevyAmendmentLogger logger = new LevyAmendmentLogger();
            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<AmendLevyContractCommand>();

            logger.Log("INFORMATION: Retrieving all LEVY contracts from CRM");

            try
            {
                IReadOnlyCollection<ContractInformation> allLevyContracts =
                    crmRepository.GetLatestContractInformationByFundingTypeAndFundingPeriod(levyFundingType, levyFundingPeriod);

                logger.Log($"INFORMATION: Found {allLevyContracts.Count} all LEVY contracts, beginning processing");

                var levyContractsForUkprns = allLevyContracts.Where(c => ukprns.Contains(c.Ukprn)).ToList();

                logger.Log($"INFORMATION: Found {levyContractsForUkprns.Count} LEVY contracts for ukprns, beginning processing");

                levyContractsForUkprns.ForEach(contract =>
                {
                    logger.Log($"INFORMATION: Sending AmendLevyContractCommand for {contract}");

                    endpoint.Send("ContractManagementDomain.LevyAmendmentEndpoint", new AmendLevyContractCommand
                    {
                        ContractInformation = contract,
                        AmendmentType = AmendmentType.Notification,
                        AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Bulk,
                        ShouldAddPayableNonLevyAllocation = true
                    }).Wait();
                });
            }
            catch (Exception ex)
            {
                logger.Log($"ERROR: An exception occurred: {ex.Message}");
            }
            finally
            {
                logger.SaveLogToDisk();
            }
        }

        [TestMethod, TestCategory("AmendAllLevyContracts")]
        public void GenerateReportOfLevyContractsNotOnRoatP()
        {
            const string levyFundingType = "LEVY";
            const string levyFundingPeriod = "LEVY1799";

            CrmContractInformationRepository crmRepository = new CrmContractInformationRepository();
            LevyAmendmentLogger logger = new LevyAmendmentLogger();

            try
            {
                IReadOnlyCollection<ContractInformation> levyContracts =
                    crmRepository.GetLatestContractInformationByFundingTypeAndFundingPeriod(levyFundingType, levyFundingPeriod);

                IReadOnlyCollection<string> validUkprns = RoatpRepository.GetValidUkprns();

                var levyContractsNotOnRoatp = levyContracts.Where(lc => !validUkprns.Contains(lc.Ukprn)).ToList();

                CsvWriter<ContractInformation> csvWriter = new CsvWriter<ContractInformation>();

                logger.Log(csvWriter.CreateCsv(levyContractsNotOnRoatp));

            }
            catch (Exception ex)
            {
                logger.Log($"ERROR: An exception occurred: {ex.Message}");
            }
            finally
            {
                logger.SaveLogToDisk();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AmendSingleLevyContract()
        {
            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<AmendLevyContractCommand>();

            endpoint.Send("ContractManagementDomain.LevyAmendmentEndpoint", new AmendLevyContractCommand
            {
                ContractInformation = new ContractInformation(contractNumber: "APPLEVY-51711",
                    masterContractNumber: "ESFA-92572",
                    contractVersionNumber: 1,
                    subVersionNumber: 0,
                    ukprn: "10027955",
                    contractStatus: ContractStatus.Draft,
                    contractSubStatus: ContractSubStatus.PublishedtoProvider),
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single
            }).Wait();
        }

        private class LevyAmendmentLogger
        {
            private readonly StringBuilder _fileLog = new StringBuilder();

            public void Log(string message)
            {
                _fileLog.AppendLine(message);
                System.Diagnostics.Debug.WriteLine(message);
            }

            public void SaveLogToDisk()
            {
                string fileName = $"LevyAmendmentFixLog_{DateTime.UtcNow.ToString("yyyy-MM-dd-HH-mm-ss")}";
                FileInfo fileInfo = new FileInfo($"LevyAmendmentDataFixLogs\\{fileName}.txt");
                fileInfo.Directory?.Create();
                File.WriteAllText(fileInfo.FullName, _fileLog.ToString());
            }
        }
    }
}
