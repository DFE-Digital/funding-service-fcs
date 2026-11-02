namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using System;

    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;

    [TestClass]
    public class FundingStreamPeriodTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingStreamPeriod_ShouldReturnTheCorrectZeroisationBehaviourWhenPersistCurrentActualsStateIsTrue()
        {
            // arrange
            FundingStreamPeriod fundingStreamPeriod = new FundingStreamPeriod
            {
                ZeroiseMissingActuals = true,
                PersistCurrentActualsState = true,
                ProcessFutureActuals = false
            };

            // act
            FundingStreamZeroisationBehaviour behaviour = fundingStreamPeriod.GetZeroisationBehaviour();

            // assert
            Assert.AreEqual(FundingStreamZeroisationBehaviour.PersistCurrentViewActualsState, behaviour);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingStreamPeriod_ShouldReturnTheCorrectZeroisationBehaviour_WhenProcessFutureActualsIsTrue()
        {
            // Arrange
            FundingStreamPeriod fundingStreamPeriod = new FundingStreamPeriod
            {
                ZeroiseMissingActuals = true,
                PersistCurrentActualsState = false,
                ProcessFutureActuals = true
            };

            // Act
            FundingStreamZeroisationBehaviour behaviour = fundingStreamPeriod.GetZeroisationBehaviour();

            // Assert
            Assert.AreEqual(FundingStreamZeroisationBehaviour.ProcessFutureActuals, behaviour);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingStreamPeriod_ShouldReturnTheCorrectZeroisationBehaviour_WhenZeroiseMissingActualsIsFalse()
        {
            // Arrange
            FundingStreamPeriod fundingStreamPeriod = new FundingStreamPeriod
            {
                ZeroiseMissingActuals = false,
                PersistCurrentActualsState = false,
                ProcessFutureActuals = false
            };

            // Act
            FundingStreamZeroisationBehaviour behaviour = fundingStreamPeriod.GetZeroisationBehaviour();

            // Assert
            Assert.AreEqual(FundingStreamZeroisationBehaviour.NotSet, behaviour);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingStreamPeriod_ShouldThrowException_WhenProcessFutureActualsAndPersistCurrentActualsStateAreTrue()
        {
            // Arrange
            FundingStreamPeriod fundingStreamPeriod = new FundingStreamPeriod
            {
                ZeroiseMissingActuals = true,
                ProcessFutureActuals = true,
                PersistCurrentActualsState = true
            };

            // Act
            try
            {
                FundingStreamZeroisationBehaviour behaviour = fundingStreamPeriod.GetZeroisationBehaviour();
            }
            catch (ArgumentException ex)
            {
                return;
            }

            // Assert
            Assert.Fail("Exception was not thrown");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingStreamPeriod_ShouldReturnTheCorrectZeroisationBehaviour_WhenOnlyZeroiseMissingActualsIsTrue()
        {
            // Arrange
            FundingStreamPeriod fundingStreamPeriod = new FundingStreamPeriod
            {
                ZeroiseMissingActuals = true,
                PersistCurrentActualsState = false,
                ProcessFutureActuals = false
            };

            // Act
            FundingStreamZeroisationBehaviour behaviour = fundingStreamPeriod.GetZeroisationBehaviour();

            // Assert
            Assert.AreEqual(FundingStreamZeroisationBehaviour.ZeroiseMissingActuals, behaviour);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingStreamPeriod_ShouldThrowException_WhenZeroiseMissingActualsIsFalseButProcessFutureActualsIsTrue()
        {
            // Arrange
            FundingStreamPeriod fundingStreamPeriod = new FundingStreamPeriod
            {
                ZeroiseMissingActuals = false,
                PersistCurrentActualsState = false,
                ProcessFutureActuals = true
            };

            // Act
            try
            {
                FundingStreamZeroisationBehaviour behaviour = fundingStreamPeriod.GetZeroisationBehaviour();
            }
            catch (ArgumentException ex)
            {
                return;
            }

            // Assert
            Assert.Fail("Exception was not thrown");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingStreamPeriod_ShouldThrowException_WhenZeroiseMissingActualsIsFalseButPersistCurrentActualsIsTrue()
        {
            // Arrange
            FundingStreamPeriod fundingStreamPeriod = new FundingStreamPeriod
            {
                ZeroiseMissingActuals = false,
                PersistCurrentActualsState = true,
                ProcessFutureActuals = false
            };

            // Act
            try
            {
                FundingStreamZeroisationBehaviour behaviour = fundingStreamPeriod.GetZeroisationBehaviour();
            }
            catch (ArgumentException ex)
            {
                return;
            }

            // Assert
            Assert.Fail("Exception was not thrown");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingStreamPeriod_ShouldThrowException_WhenZeroiseMissingActualsIsFalseButProcessFutureActualsAndPersistCurrentActualsAreTrue()
        {
            // Arrange
            FundingStreamPeriod fundingStreamPeriod = new FundingStreamPeriod
            {
                ZeroiseMissingActuals = false,
                ProcessFutureActuals = true,
                PersistCurrentActualsState = true
            };

            // Act
            try
            {
                FundingStreamZeroisationBehaviour behaviour = fundingStreamPeriod.GetZeroisationBehaviour();
            }
            catch (ArgumentException ex)
            {
                return;
            }

            // Assert
            Assert.Fail("Exception was not thrown");
        }
    }
}
