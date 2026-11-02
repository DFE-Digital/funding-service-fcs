namespace FCT.Operations.Cda.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Cda.Dtos;
    using Cda.Repositories;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using ReportGeneration;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Dtos;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ReportCreationServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ReportCreationServiceTest_ShouldProduceReports()
        {
            // arrange
            List<ReportExtractGroup> groups = new List<ReportExtractGroup>
            {
                new ReportExtractGroup
                {
                    ExtractName = "Mainstream 17-18",
                    FspCodes = new List<string>
                    {
                        "FSP1",
                        "FSP2",
                        "FSP3"
                    }
                },
                new ReportExtractGroup
                {
                    ExtractName = "Mainstream 18-19",
                    FspCodes = new List<string>
                    {
                        "FSP4",
                        "FSP5",
                        "FSP6"
                    }
                },
                new ReportExtractGroup
                {
                    ExtractName = "Some Other Extract",
                    FspCodes = new List<string>
                    {
                        "FSP10"
                    }
                }
            };

            List<CdaRow> rows = new List<CdaRow>
            {
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP1",
                    ActualEarned = "1",
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP1",
                    ActualEarned = "2"
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP4",
                    ActualEarned = "1"
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP4",
                    ActualEarned = "1"
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP6",
                    ActualEarned = "1"
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP6",
                    ActualEarned = "1"
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP5",
                    ActualEarned = "1"
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP10",
                    ActualEarned = "1"
                }
            };
            ReportCreationService service = new ReportCreationService(Mock.Of<IClosedContractRepository>(), Mock.Of<IOverrideDateRepository>());

            // act
            var reports = service.GetReports(rows, groups, isLatest: false, ConnectionInfo.CreateDefault()).Result;

            // assert
            Assert.AreEqual(3, reports.Count, "The number of reports is incorrect");


            var reportForSomeOther =
                reports.FirstOrDefault(r => r.ReportName == "CDA Last Approved Version Some Other Extract.csv");
            Assert.IsNotNull(reportForSomeOther, "The CDA Last Approved Version Some Other Extract.csv is not present");
            Assert.AreEqual(1, reportForSomeOther.Rows.Count,
                "The number of row in CDA Last Approved VersionSome Other Extract.csv is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReportCreationServiceTest_ShouldProduceReportsOnlyForLastApprovedIfAsked()
        {
            // arrange
            List<ReportExtractGroup> groups = new List<ReportExtractGroup>
            {
                new ReportExtractGroup
                {
                    ExtractName = "Mainstream 17-18",
                    FspCodes = new List<string>
                    {
                        "FSP1",
                        "FSP2",
                        "FSP3"
                    }
                },
                new ReportExtractGroup
                {
                    ExtractName = "Mainstream 18-19",
                    FspCodes = new List<string>
                    {
                        "FSP4",
                        "FSP5",
                        "FSP6"
                    }
                },
                new ReportExtractGroup
                {
                    ExtractName = "Some Other Extract",
                    FspCodes = new List<string>
                    {
                        "FSP10"
                    }
                }
            };

            List<CdaRow> rows = new List<CdaRow>
            {
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP1",
                    ActualEarned = "1"
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP1",
                    ActualEarned = "2"
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP4",
                    ActualEarned = "1"
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP4",
                    ActualEarned = "1"
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP6",
                    ActualEarned = "1"
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP6",
                    ActualEarned = "1"
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP5",
                    ActualEarned = "1"
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP10",
                    ActualEarned = "1"
                }
            };
            ReportCreationService service = new ReportCreationService(Mock.Of<IClosedContractRepository>(), Mock.Of<IOverrideDateRepository>());

            // act
            var reports = service.GetReports(rows, groups, isLatest: false, ConnectionInfo.CreateDefault()).Result;

            // assert
            Assert.AreEqual(3, reports.Count, "The number of reports is incorrect");

            var mainstream1718_Rows =
                reports.Single(r => r.ReportName == "CDA Last Approved Version Mainstream 17-18.csv").Rows;
            Assert.AreEqual(2, mainstream1718_Rows.Count, "The number of rows for Mainstream 17-18 is incorrect");
            var mainstream18_19_Rows =
                reports.Single(r => r.ReportName == "CDA Last Approved Version Mainstream 18-19.csv").Rows;
            Assert.AreEqual(5, mainstream18_19_Rows.Count, "The number of rows for Mainstream 18-19 is incorrect");
            var someOtherExtract_Rows =
                reports.Single(r => r.ReportName == "CDA Last Approved Version Some Other Extract.csv").Rows;
            Assert.AreEqual(1, someOtherExtract_Rows.Count, "The number of rows for Some Other Extract is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReportCreationServiceTest_ShouldProduceClosedArchiveReportsWhenArchiveIsTrueAndLastApproved()
        {
            // assert
            const string closedContractNumber = "CN-CLS1";
            const string fspCodeOfClosedContracts = "FSP1";
            const int currentYear = 2022;

            List<ReportExtractGroup> groups = new List<ReportExtractGroup>
            {
                new ReportExtractGroup
                {
                    ExtractName = "Mainstream 17-18",
                    ArchiveClosedContracts = true,
                    FspCodes = new List<string>
                    {
                        fspCodeOfClosedContracts
                    }
                },
                new ReportExtractGroup
                {
                    ExtractName = "Mainstream 18-19",
                    FspCodes = new List<string>
                    {
                        "FSP4"
                    }
                }
            };

            List<CdaRow> rows = new List<CdaRow>
            {
                new CdaRow
                {
                    FundingStreamPeriodCode = fspCodeOfClosedContracts,
                    ContractNumber = closedContractNumber
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = fspCodeOfClosedContracts,
                    ContractNumber = "Some other"
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP4"
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP4"
                    
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP6"
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP6"
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP5"
                },
                new CdaRow
                {
                    FundingStreamPeriodCode = "FSP10"
                }
            };
            Mock<IClosedContractRepository> closedContractRepositoryMock = new Mock<IClosedContractRepository>();
            closedContractRepositoryMock.Setup(r =>
                    r.GetContractNumbersClosedInPreviousYears(It.IsAny<IEnumerable<string>>(), It.IsAny<int>(),
                        It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new List<(string contractNumber, int year)>()
                {
                    (closedContractNumber, currentYear - 1)
                });
            Mock<IOverrideDateRepository> overrideDateRepositoryMock = new Mock<IOverrideDateRepository>();
            overrideDateRepositoryMock.Setup(r => r.GetDate(It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new DateTime(currentYear, 1, 1));

            ReportCreationService service = new ReportCreationService(closedContractRepositoryMock.Object, overrideDateRepositoryMock.Object);

            // act
            var reports = service.GetReports(rows, groups, isLatest: false, ConnectionInfo.CreateDefault()).Result;

            // assert
            reports.Count.Should().Be(3);
            var archivedReport = reports.Single(r => r.IsArchiveClosedContractReport);
            archivedReport.Rows.Count.Should().Be(1);
            archivedReport.ArchivedYear.Should().Be(currentYear - 1);
            archivedReport.Rows.Single().ContractNumber.Should().Be(closedContractNumber);
            archivedReport.ReportName.Should().Be("CDA Mainstream 17-18 (Closed in 2021).csv");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReportCreationServiceTest_ShouldProduceFileWithSuffix()
        {
            // assert
            List<ReportExtractGroup> groups = new List<ReportExtractGroup>
            {
                new ReportExtractGroup
                {
                    ExtractName = null,
                    FspCodes = new List<string>
                    {
                        "FSP4"
                    },
                    Suffix = "A979"
                }
            };

            List<CdaRow> rows = new List<CdaRow>
            {
                new CdaRow
                {
                    FundingStreamPeriodCode = "Some fsp",
                    ContractNumber = "some number"
                },
            };
        
            Mock<IOverrideDateRepository> overrideDateRepositoryMock = new Mock<IOverrideDateRepository>();
            overrideDateRepositoryMock.Setup(r => r.GetDate(It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(DateTime.Now);

            ReportCreationService service = new ReportCreationService(Mock.Of<IClosedContractRepository>(), overrideDateRepositoryMock.Object);

            // act
            var reports = service.GetReports(rows, groups, isLatest: true, ConnectionInfo.CreateDefault()).Result;

            // assert
            reports.Count.Should().Be(1);
            var report = reports.Single();
            report.ReportName.Should().Be("CDA Latest Version A979.csv");
        }
    }
}
