namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Repositories;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.AllocationDeliveryDomain.Endpoint.BusinessLogic.Validator;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ActualValidatorTests
    {
        private Mock<IDate> _dateMock;
        private Mock<ILogger> _loggerMock;
        private Mock<IFundingStreamConfigurationStore> _fundingStreamConfigStoreMock;

        [TestMethod, TestCategory("UnitTest")]
        public void Validate_ShouldReturnFalse_IfEnrichedReportedActualDoesNotHaveAnAllocationNumber()
        {
            // Arrange
            var fixedDate = new DateTime(2015, 9, 4);

            var systemDate = new Mock<IDate>();
            systemDate.Setup(sd => sd.GetCalculationDate()).Returns(fixedDate);

            var actual = new EnrichedReportedActual
            {
                ContractAllocationNumber = null,
                ActualValue = 10,
                ActualVolume = 1,
                AllocationStartDate = new DateTime(2015, 08, 01),
                AllocationEndDate = new DateTime(2016, 07, 31),
                DeliverableCode = "2",
                EnrichedDeliverableCode = "2",
                Period = "201509"
            };

            var validator = new ActualValidator
            {
                Date = systemDate.Object,
                AllocationsUnderTerminationQueryRepository = Mock.Of<IAllocationsUnderTerminationQueryRepository>()
            };

            // Act
            var isValid = !validator.Validate(actual, false, ConnectionInfo.CreateDefault()).Any();

            // Assert
            Assert.IsFalse(isValid,
                "Validate did not return false then the contract allocation number was null");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void Validate_ShouldReturnFalse_IfEnrichedReportedActualDoesNotHaveAnEnrichedDeliverableCode()
        {
            // Arrange
            var fixedDate = new DateTime(2015, 9, 4);

            var systemDate = new Mock<IDate>();
            systemDate.Setup(sd => sd.GetCalculationDate()).Returns(fixedDate);

            var actual = new EnrichedReportedActual
            {
                ContractAllocationNumber = "ALLOC-001",
                ActualValue = 10,
                ActualVolume = 1,
                AllocationStartDate = new DateTime(2015,
                    08,
                    01),
                AllocationEndDate = new DateTime(2016,
                    07,
                    31),
                EnrichedDeliverableCode = null,
                Period = "201509"
            };

            var validator = new ActualValidator()
            {
                Date = systemDate.Object,
                AllocationsUnderTerminationQueryRepository = Mock.Of<IAllocationsUnderTerminationQueryRepository>()
            };

            // Act
            var isValid = !validator.Validate(actual, false, ConnectionInfo.CreateDefault()).Any();

            // Assert
            Assert.IsFalse(isValid,
                "Validate did not return false then the enriched deliverable code was null");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Validate_ShouldReturnFalse_IfEnrichedReportedActualPeriodIsBeforenAllocationStartDate()
        {
            // Arrange
            var fixedDate = new DateTime(2015, 9, 4);

            var systemDate = new Mock<IDate>();
            systemDate.Setup(sd => sd.GetCalculationDate()).Returns(fixedDate);

            var actual = new EnrichedReportedActual
            {
                ContractAllocationNumber = "ALLOC-001",
                ActualValue = 10,
                ActualVolume = 1,
                AllocationStartDate = new DateTime(2015,
                    08,
                    01),
                AllocationEndDate = new DateTime(2016,
                    07,
                    31),
                EnrichedDeliverableCode = "1",
                Period = "201507"
            };

            var validator = new ActualValidator()
            {
                Date = systemDate.Object,
                AllocationsUnderTerminationQueryRepository = Mock.Of<IAllocationsUnderTerminationQueryRepository>()
            };

            // Act
            var isValid = !validator.Validate(actual, false, ConnectionInfo.CreateDefault()).Any();

            // Assert
            Assert.IsFalse(isValid,
                "Validate allowed an actual period before allocation start date");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Validate_ShouldReturnFalse_IfEnrichedReportedActualPeriodIsAfterAllocationEndDate()
        {
            // Arrange
            var fixedDate = new DateTime(2015, 9, 4);

            var systemDate = new Mock<IDate>();
            systemDate.Setup(sd => sd.GetCalculationDate()).Returns(fixedDate);

            var actual = new EnrichedReportedActual
            {
                ContractAllocationNumber = "ALLOC-001",
                ActualValue = 10,
                ActualVolume = 1,
                AllocationStartDate = new DateTime(2015,
                    08,
                    01),
                AllocationEndDate = new DateTime(2016,
                    07,
                    31),
                EnrichedDeliverableCode = "1",
                Period = "201608"
            };

            var validator = new ActualValidator()
            {
                Date = systemDate.Object,
                AllocationsUnderTerminationQueryRepository = Mock.Of<IAllocationsUnderTerminationQueryRepository>()
            };

            // Act
            var isValid = !validator.Validate(actual, false, ConnectionInfo.CreateDefault()).Any();

            // Assert
            Assert.IsFalse(isValid,
                "Validate allowed an actual period after allocation end date");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void
            Validate_ShouldReturnTrue_IfEnrichedReportedActualHasAnAllocationAndHasADeliverableAndItsPeriodFallsWithinAllocationStartAndEndDates()
        {
            // Arrange
            var fixedDate = new DateTime(2015, 9, 4);

            var systemDate = new Mock<IDate>();
            systemDate.Setup(sd => sd.GetCalculationDate()).Returns(fixedDate);


            var actual = new EnrichedReportedActual
            {
                ContractAllocationNumber = "ALLOC-001",
                ActualValue = 10,
                ActualVolume = 1,
                AllocationStartDate = new DateTime(2015,
                    08,
                    01),
                AllocationEndDate = new DateTime(2016,
                    07,
                    31),
                EnrichedDeliverableCode = "1",
                Period = "201508"
            };

            var validator = new ActualValidator()
            {
                Date = systemDate.Object,
                AllocationsUnderTerminationQueryRepository = Mock.Of<IAllocationsUnderTerminationQueryRepository>()
            };

            // Act
            var isValid = !validator.Validate(actual, false, ConnectionInfo.CreateDefault()).Any();

            // Assert
            Assert.IsTrue(isValid,
                "Validate did not return true");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Validate_ShouldReturnFalse_IfEnrichedReportedActualHasAPeriodGreaterThanTheCurrentPeriod()
        {
            // Arrange
            Mock<IDate> dateProviderMock = new Mock<IDate>();
            dateProviderMock
                .Setup(m => m.GetCalculationDate())
                .Returns(new DateTime(2015, 9, 4, 11, 0, 0, DateTimeKind.Utc));

            var actual = new EnrichedReportedActual
            {
                ContractAllocationNumber = "ALLOC-001",
                ActualValue = 10,
                ActualVolume = 1,
                AllocationStartDate = new DateTime(2015, 08, 01),
                AllocationEndDate = new DateTime(2016, 07, 31),
                EnrichedDeliverableCode = "1",
                Period = "201509"
            };

            var validator = new ActualValidator()
            {
                Date = dateProviderMock.Object,
                AllocationsUnderTerminationQueryRepository = Mock.Of<IAllocationsUnderTerminationQueryRepository>()
            };

            // Act
            var results = validator.Validate(actual, false, ConnectionInfo.CreateDefault());

            //do not want to log for future actuals validation so no elements expected in results Story 7685
            Assert.IsFalse(results.Any());

            // Assert
            Assert.IsFalse(actual.IsValid, "Validate did not return false");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Validate_ShouldReturnTrue_IfEnrichedReportedActualHasAPeriodLessThanTheCurrentPeriod()
        {
            // Arrange
            var fixedDate = new DateTime(2015, 9, 4);

            var systemDate = new Mock<IDate>();
            systemDate.Setup(sd => sd.GetCalculationDate()).Returns(fixedDate);

            var actual = new EnrichedReportedActual
            {
                ContractAllocationNumber = "ALLOC-001",
                ActualValue = 10,
                ActualVolume = 1,
                AllocationStartDate = new DateTime(2015, 08, 01),
                AllocationEndDate = new DateTime(2016, 07, 31),
                EnrichedDeliverableCode = "1",
                Period = "201508"
            };

            var validator = new ActualValidator()
            {
                Date = systemDate.Object,
                AllocationsUnderTerminationQueryRepository = Mock.Of<IAllocationsUnderTerminationQueryRepository>()
            };

            // Act
            var isValid = !validator.Validate(actual, false, ConnectionInfo.CreateDefault()).Any();

            // Assert
            Assert.IsTrue(isValid,
                "Validate did not return true");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ActualValidator_GetValidActuals_ShouldRemoveFutureActualsWhenFundingStreamPeriodBehaviourIsNotProcessFutureActuals()
        {
            // Arrange
            string fspCode = "FSP1617";
            SetupMocks(shouldProcessFutureActuals: false, fspCode: fspCode, date: new DateTime(2016, 10, 05));

            var actualValidator = new ActualValidator
            {
                Date = _dateMock.Object,
                Logger = _loggerMock.Object,
                Store = _fundingStreamConfigStoreMock.Object,
                AllocationsUnderTerminationQueryRepository = Mock.Of<IAllocationsUnderTerminationQueryRepository>()
            };

            // Act
            var enrichedReportedActuals = CreateEnrichedReportedActuals(fspCode);
            var validatedActuals = actualValidator.GetValidActuals(enrichedReportedActuals, ConnectionInfo.CreateDefault());

            // Assert
            Assert.AreEqual(2, validatedActuals.Count);

            Assert.IsTrue(enrichedReportedActuals[0].IsValid, "Enriched actual 1 was not valid");
            Assert.IsTrue(enrichedReportedActuals[1].IsValid, "Enriched actual 2 was not valid");
            Assert.IsFalse(enrichedReportedActuals[2].IsValid, "Enriched actual 3 was valid");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ActualValidator_GetValidActuals_ShouldNotRemoveFutureActualsWhenFundingStreamPeriodBehaviourIsProcessFutureActuals()
        {
            // Arrange
            string fspCode = "FSPFuture1617";
            SetupMocks(shouldProcessFutureActuals: true, fspCode: fspCode, date: new DateTime(2016, 10, 05));

            var actualValidator = new ActualValidator
            {
                Date = _dateMock.Object,
                Logger = _loggerMock.Object,
                Store = _fundingStreamConfigStoreMock.Object,
                AllocationsUnderTerminationQueryRepository = Mock.Of<IAllocationsUnderTerminationQueryRepository>()
            };

            // Act
            var enrichedReportedActuals = CreateEnrichedReportedActuals(fspCode);
            var validActuals = actualValidator.GetValidActuals(enrichedReportedActuals, ConnectionInfo.CreateDefault());

            // Assert
            Assert.AreEqual(3, validActuals.Count);

            enrichedReportedActuals
                .ForEach(actual => Assert.IsTrue(actual.IsValid, $"actual is invalid period: {actual.Period}"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ActualValidator_GetValidActuals_ShouldNotCreateInformationLogEntryWhenActualIsInTheFuture()
        {
            // Arrange
            string fspCode = "FSPFuture1617";
            SetupMocks(shouldProcessFutureActuals: false, fspCode: fspCode, date: new DateTime(2016, 10, 05));

            var actualValidator = new ActualValidator
            {
                Date = _dateMock.Object,
                Logger = _loggerMock.Object,
                Store = _fundingStreamConfigStoreMock.Object,
                AllocationsUnderTerminationQueryRepository = Mock.Of<IAllocationsUnderTerminationQueryRepository>()
            };

            // Act
            var enrichedReportedActuals = CreateEnrichedReportedActuals(fspCode);
            actualValidator.GetValidActuals(enrichedReportedActuals, ConnectionInfo.CreateDefault());

            // Assert
            _loggerMock.Verify(l => l.LogInformation(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<object[]>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Validate_ShouldReturnTrue_IfCalcDateIsAfterActitivyCloseDateForFSP()
        {
            // Arrange
            var fixedDate = new DateTime(2020, 1, 1);
            const string fspCode = "16-18APPS1516";
            SetupMocks(shouldProcessFutureActuals: false, fspCode: fspCode, date: fixedDate,
                activityCloseDate: fixedDate.AddDays(-1));

            var validator = new ActualValidator
            {
                Date = _dateMock.Object,
                Logger = _loggerMock.Object,
                Store = _fundingStreamConfigStoreMock.Object
            };

            // Act
            var isCalcDateAfterActivityCloseDate = validator.IsCalcDateAfterFspActivityCloseDate(fspCode, ConnectionInfo.CreateDefault());

            // Assert
            Assert.IsTrue(isCalcDateAfterActivityCloseDate,
                "Validate did not return True when the CalcDate was after the ActivityCloseDate");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Validate_ShouldReturnFalse_IfCalcDateIsOnActitivyCloseDateForFSP()
        {
            // Arrange
            var fixedDate = new DateTime(2020, 1, 1, 12, 0, 0);
            const string fspCode = "16-18APPS1516";
            SetupMocks(shouldProcessFutureActuals: false, fspCode: fspCode, date: fixedDate,
                activityCloseDate: fixedDate.AddHours(-1));

            var validator = new ActualValidator
            {
                Date = _dateMock.Object,
                Logger = _loggerMock.Object,
                Store = _fundingStreamConfigStoreMock.Object
            };

            // Act
            var isCalcDateAfterActivityCloseDate = validator.IsCalcDateAfterFspActivityCloseDate(fspCode, ConnectionInfo.CreateDefault());

            // Assert
            Assert.IsFalse(isCalcDateAfterActivityCloseDate,
                "Validate did not return False when the CalcDate was on the ActivityCloseDate");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Validate_ShouldReturnFalse_IfCalcDateIsBeforeActitivyCloseDateForFSP()
        {
            // Arrange
            var fixedDate = new DateTime(2020, 1, 1);
            const string fspCode = "16-18APPS1516";
            SetupMocks(shouldProcessFutureActuals: false, fspCode: fspCode, date: fixedDate,
                activityCloseDate: fixedDate.AddDays(+1));

            var validator = new ActualValidator
            {
                Date = _dateMock.Object,
                Logger = _loggerMock.Object,
                Store = _fundingStreamConfigStoreMock.Object
            };

            // Act
            var isCalcDateAfterActivityCloseDate = validator.IsCalcDateAfterFspActivityCloseDate(fspCode, ConnectionInfo.CreateDefault());

            // Assert
            Assert.IsFalse(isCalcDateAfterActivityCloseDate,
                "Validate did not return False when the CalcDate was before the ActivityCloseDate");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Validate_ShouldReturnTrue_IfFSPHasNoActitivyCloseDateForActual()
        {
            // Arrange
            var fixedDate = new DateTime(2020, 1, 1);
            const string fspCode = "16-18APPS1516";
            SetupMocks(shouldProcessFutureActuals: false, fspCode: fspCode, date: fixedDate, activityCloseDate: null);

                var validator = new ActualValidator
                {
                    Date = _dateMock.Object,
                    Logger = _loggerMock.Object,
                    Store = _fundingStreamConfigStoreMock.Object
                };

            // Act
            var isCalcDateAfterActivityCloseDate = validator.IsCalcDateAfterFspActivityCloseDate(fspCode, ConnectionInfo.CreateDefault());

            // Assert
            Assert.IsFalse(isCalcDateAfterActivityCloseDate,
                    "Validate did not return False when the FSP has no ActivityCloseDate");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ActualsValidator_GetValidActuals_ShouldInvalidateAndRemoveActualsBeyondAllocationTerminationDate()
        {
            DateTime currentDate = new DateTime(2018, 11, 06, 0, 0, 0, DateTimeKind.Utc);
            DateTime terminationDate = new DateTime(2018, 09, 15, 0, 0, 0, DateTimeKind.Utc);

            // arrange
            Mock<IDate> dateProviderMock = new Mock<IDate>();
            dateProviderMock
                .Setup(m => m.GetCalculationDate())
                .Returns(currentDate);

            Mock<IAllocationsUnderTerminationQueryRepository> allocationsUnderTerminationQueryRepositoryMock = new Mock<IAllocationsUnderTerminationQueryRepository>();
            allocationsUnderTerminationQueryRepositoryMock
                .Setup(m => m.GetTerminationDate(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(terminationDate);

            ActualValidator validator = new ActualValidator
            {
                Logger = Mock.Of<ILogger>(),
                Store = Mock.Of<IFundingStreamConfigurationStore>(),
                Date = dateProviderMock.Object,
                AllocationsUnderTerminationQueryRepository = allocationsUnderTerminationQueryRepositoryMock.Object
            };

            List<EnrichedReportedActual> inputActuals = new List<EnrichedReportedActual>
            {
                new EnrichedReportedActual
                {
                    ContractAllocationNumber = "ALLOC-123",
                    AllocationStartDate = new DateTime(2018, 08, 01, 0, 0, 0, DateTimeKind.Utc),
                    AllocationEndDate = new DateTime(2019, 07, 31, 0, 0, 0, DateTimeKind.Utc),
                    EnrichedDeliverableCode = "1",
                    Period = "201808",
                    FundingStreamPeriodCode = "FSP1819"
                },
                new EnrichedReportedActual
                {
                    ContractAllocationNumber = "ALLOC-123",
                    AllocationStartDate = new DateTime(2018, 08, 01, 0, 0, 0, DateTimeKind.Utc),
                    AllocationEndDate = new DateTime(2019, 07, 31, 0, 0, 0, DateTimeKind.Utc),
                    EnrichedDeliverableCode = "1",
                    Period = "201809",
                    FundingStreamPeriodCode = "FSP1819"
                },
                new EnrichedReportedActual
                {
                    ContractAllocationNumber = "ALLOC-123",
                    AllocationStartDate = new DateTime(2018, 08, 01, 0, 0, 0, DateTimeKind.Utc),
                    AllocationEndDate = new DateTime(2019, 07, 31, 0, 0, 0, DateTimeKind.Utc),
                    EnrichedDeliverableCode = "1",
                    Period = "201810",
                    FundingStreamPeriodCode = "FSP1819"
                }
            };

            // act
            List<EnrichedReportedActual> validatedActuals = validator.GetValidActuals(inputActuals, ConnectionInfo.CreateDefault());

            // assert
            Assert.IsNotNull(validatedActuals.SingleOrDefault(a => a.Period == "201808"), "Valid actual removed for earlier month than termination date");
            Assert.IsNotNull(validatedActuals.SingleOrDefault(a => a.Period == "201809"), "Valid actual removed for same month as termination date");
            Assert.IsNull(validatedActuals.SingleOrDefault(a => a.Period == "201810"), "Invalid actual not removed for later month than termination date");
            Assert.AreEqual(2, validatedActuals.Count, "Unexpected number of valid actuals returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ActualsValidator_GetValidActuals_ShouldNotInvalidateAndRemoveActualsWhenAllocationTerminationDateIsNotPresent()
        {
            DateTime currentDate = new DateTime(2018, 11, 06, 0, 0, 0, DateTimeKind.Utc);

            // arrange
            Mock<IDate> dateProviderMock = new Mock<IDate>();
            dateProviderMock
                .Setup(m => m.GetCalculationDate())
                .Returns(currentDate);

            Mock<IAllocationsUnderTerminationQueryRepository> allocationsUnderTerminationQueryRepositoryMock = new Mock<IAllocationsUnderTerminationQueryRepository>();
            allocationsUnderTerminationQueryRepositoryMock
                .Setup(m => m.GetTerminationDate(It.IsAny<string>(), ConnectionInfo.CreateDefault()))
                .Returns<DateTime?>(null);

            ActualValidator validator = new ActualValidator
            {
                Logger = Mock.Of<ILogger>(),
                Store = Mock.Of<IFundingStreamConfigurationStore>(),
                Date = dateProviderMock.Object,
                AllocationsUnderTerminationQueryRepository = allocationsUnderTerminationQueryRepositoryMock.Object
            };

            List<EnrichedReportedActual> inputActuals = new List<EnrichedReportedActual>
            {
                new EnrichedReportedActual
                {
                    ContractAllocationNumber = "ALLOC-123",
                    AllocationStartDate = new DateTime(2018, 08, 01, 0, 0, 0, DateTimeKind.Utc),
                    AllocationEndDate = new DateTime(2019, 07, 31, 0, 0, 0, DateTimeKind.Utc),
                    EnrichedDeliverableCode = "1",
                    Period = "201808",
                    FundingStreamPeriodCode = "FSP1819"
                },
                new EnrichedReportedActual
                {
                    ContractAllocationNumber = "ALLOC-123",
                    AllocationStartDate = new DateTime(2018, 08, 01, 0, 0, 0, DateTimeKind.Utc),
                    AllocationEndDate = new DateTime(2019, 07, 31, 0, 0, 0, DateTimeKind.Utc),
                    EnrichedDeliverableCode = "1",
                    Period = "201809",
                    FundingStreamPeriodCode = "FSP1819"
                },
                new EnrichedReportedActual
                {
                    ContractAllocationNumber = "ALLOC-123",
                    AllocationStartDate = new DateTime(2018, 08, 01, 0, 0, 0, DateTimeKind.Utc),
                    AllocationEndDate = new DateTime(2019, 07, 31, 0, 0, 0, DateTimeKind.Utc),
                    EnrichedDeliverableCode = "1",
                    Period = "201810",
                    FundingStreamPeriodCode = "FSP1819"
                }
            };

            // act
            List<EnrichedReportedActual> validatedActuals = validator.GetValidActuals(inputActuals, ConnectionInfo.CreateDefault());

            // assert
            Assert.IsNotNull(validatedActuals.SingleOrDefault(a => a.Period == "201808"), "Valid actual removed");
            Assert.IsNotNull(validatedActuals.SingleOrDefault(a => a.Period == "201809"), "Valid actual removed");
            Assert.IsNotNull(validatedActuals.SingleOrDefault(a => a.Period == "201810"), "Valid actual removed");
            Assert.AreEqual(3, validatedActuals.Count, "Unexpected number of valid actuals returned");
        }

        private void SetupMocks(bool shouldProcessFutureActuals, string fspCode, DateTime date, DateTime? activityCloseDate = null)
        {
            var fundingStreamPeriod = new FundingStreamPeriod
            {
                Name = "FSPName",
                Code = fspCode,
                ProcessFutureActuals = shouldProcessFutureActuals,
                ActivityCloseDate = activityCloseDate
            };

            _dateMock = new Mock<IDate>();
            _dateMock.Setup(x => x.GetCalculationDate()).Returns(date);

            _loggerMock = new Mock<ILogger>();
            _fundingStreamConfigStoreMock = new Mock<IFundingStreamConfigurationStore>();
            _fundingStreamConfigStoreMock.Setup(
                x => x.GetFundingStreamPeriod(
                    It.Is<string>(s => s == fspCode), It.IsAny<ConnectionInfo>()))
                    .Returns(fundingStreamPeriod);
        }

        private List<EnrichedReportedActual> CreateEnrichedReportedActuals(string fspCode)
        {
            return new List<EnrichedReportedActual>
            {
                CreateSingleEnrichedReportedActual("201608", fspCode),
                CreateSingleEnrichedReportedActual("201609", fspCode),
                CreateSingleEnrichedReportedActual("201610", fspCode),
            };
        }

        private EnrichedReportedActual CreateSingleEnrichedReportedActual(string period, string fspCode)
        {
            return new EnrichedReportedActual
            {
                ActualValue = 10,
                ActualVolume = 0,
                AllocationStartDate = new DateTime(2016, 08, 01),
                AllocationEndDate = new DateTime(2017, 07, 31),
                ContractNumber = "Main-1234",
                Period = period,
                OrganisationId = "ORG000001",
                DeliverableCode = "1",
                ContractVersion = 1,
                FundingStreamPeriodCode = fspCode,
                PeriodTypeCode = "CM",
                CollectionReturnCode = "R01",
                CollectionType = "ILR1516",
                ContractAllocationNumber = "ALLOC-01",
                ContractSubVersion = 1,
                DeliverablePeriodMatch = true,
                EnrichedDeliverableCode = "1",
                Ukprn = "122200"
            };
        }
    }
}
