namespace Datafix.Tests.Tests
{
    using System.Collections.Generic;
    using Dtos;
    using Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class DeliverablePeriodPlannedValuesExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriodPlannedValuesExtensions_ShouldGetStartYear()
        {
            // arrange
            List<DeliverablePeriodPlannedValue> periodPlannedValues = new List<DeliverablePeriodPlannedValue>
            {
                new DeliverablePeriodPlannedValue("201908", 10),
                new DeliverablePeriodPlannedValue("201909", 10),
                new DeliverablePeriodPlannedValue("201910", 10),
                new DeliverablePeriodPlannedValue("201911", 10),
                new DeliverablePeriodPlannedValue("201912", 10),
                new DeliverablePeriodPlannedValue("202001", 10),
                new DeliverablePeriodPlannedValue("202002", 10)
            };

            // act
            int startYear = periodPlannedValues.GetStartYear();
            
            // assert
            Assert.AreEqual(2019, startYear);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriodPlannedValuesExtensions_ShouldGetEndYear()
        {
            // arrange
            List<DeliverablePeriodPlannedValue> periodPlannedValues = new List<DeliverablePeriodPlannedValue>
            {
                new DeliverablePeriodPlannedValue("201908", 10),
                new DeliverablePeriodPlannedValue("201909", 10),
                new DeliverablePeriodPlannedValue("201910", 10),
                new DeliverablePeriodPlannedValue("201911", 10),
                new DeliverablePeriodPlannedValue("201912", 10),
                new DeliverablePeriodPlannedValue("202001", 10),
                new DeliverablePeriodPlannedValue("202002", 10)
            };

            // act
            int endYear = periodPlannedValues.GetEndYear();

            // assert
            Assert.AreEqual(2020, endYear);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriodPlannedValuesExtensions_ShouldGetFirstEnvelope()
        {
            // arrange
            List<DeliverablePeriodPlannedValue> periodPlannedValues = new List<DeliverablePeriodPlannedValue>
            {
                new DeliverablePeriodPlannedValue("201908", 10),
                new DeliverablePeriodPlannedValue("201909", 10),
                new DeliverablePeriodPlannedValue("201910", 10),
                new DeliverablePeriodPlannedValue("201911", 10),
                new DeliverablePeriodPlannedValue("201912", 10),
                new DeliverablePeriodPlannedValue("202001", 10),
                new DeliverablePeriodPlannedValue("202002", 10),
                new DeliverablePeriodPlannedValue("202003", 10),
                new DeliverablePeriodPlannedValue("202004", 10),
                new DeliverablePeriodPlannedValue("202005", 10),
                new DeliverablePeriodPlannedValue("202006", 10),
                new DeliverablePeriodPlannedValue("202007", 10),
            };

            // act
            decimal firstEnvelope = periodPlannedValues.GetFirstEnvelope(2019);

            // assert
            Assert.AreEqual(80, firstEnvelope);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriodPlannedValuesExtensions_ShouldGetSecondEnvelope()
        {
            // arrange
            List<DeliverablePeriodPlannedValue> periodPlannedValues = new List<DeliverablePeriodPlannedValue>
            {
                new DeliverablePeriodPlannedValue("201908", 10),
                new DeliverablePeriodPlannedValue("201909", 10),
                new DeliverablePeriodPlannedValue("201910", 10),
                new DeliverablePeriodPlannedValue("201911", 10),
                new DeliverablePeriodPlannedValue("201912", 10),
                new DeliverablePeriodPlannedValue("202001", 10),
                new DeliverablePeriodPlannedValue("202002", 10),
                new DeliverablePeriodPlannedValue("202003", 10),
                new DeliverablePeriodPlannedValue("202004", 10),
                new DeliverablePeriodPlannedValue("202005", 10),
                new DeliverablePeriodPlannedValue("202006", 10),
                new DeliverablePeriodPlannedValue("202007", 10),
            };

            // act
            decimal envelope = periodPlannedValues.GetSecondEnvelope(2020);

            // assert
            Assert.AreEqual(40, envelope);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriodPlannedValuesExtensions_ShouldGetFirstEnvelopeForShortContract()
        {
            // arrange
            List<DeliverablePeriodPlannedValue> periodPlannedValues = new List<DeliverablePeriodPlannedValue>
            {
                new DeliverablePeriodPlannedValue("202001", 10),
                new DeliverablePeriodPlannedValue("202002", 10),
                new DeliverablePeriodPlannedValue("202003", 10),
                new DeliverablePeriodPlannedValue("202004", 10),
                new DeliverablePeriodPlannedValue("202005", 10),
                new DeliverablePeriodPlannedValue("202006", 10),
                new DeliverablePeriodPlannedValue("202007", 10),
            };

            // act
            decimal firstEnvelope = periodPlannedValues.GetFirstEnvelope(2020);

            // assert
            Assert.AreEqual(30, firstEnvelope);
        }
    }
}
