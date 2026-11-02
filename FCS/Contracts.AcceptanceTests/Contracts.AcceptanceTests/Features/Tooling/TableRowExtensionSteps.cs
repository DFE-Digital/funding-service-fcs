namespace SFA.FCT.Contracts.AcceptanceTests.Features.Tooling
{
    using System;
    using System.Linq;
    using Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using TechTalk.SpecFlow;

    [Binding]
    public class TableRowExtensionSteps
    {
        private TestType _testTypeInstance;

        [Given(@"a TestType instance as follows")]
        public void GivenATestTypeInstanceAsFollows(Table table)
        {
            _testTypeInstance = table.Rows.Single().CreateInstance<TestType>();
        }

        [Given(@"a TestType instance with null values")]
        public void GivenATestTypeInstanceWithNullValues()
        {
            _testTypeInstance = new TestType
            {
                Prop1 = null,
                Prop2 = null
            };
        }

        [Then(@"the following values should be present in the instance")]
        public void ThenTheFollowingValuesShouldBePresentInTheInstance(Table table)
        {
            TableRow row = table.Rows.Single();

            Assert.AreEqual(row["Prop1"], _testTypeInstance.Prop1);
            Assert.AreEqual(row["Prop2"], _testTypeInstance.Prop2);
            Assert.AreEqual((TestEnum)Enum.Parse(typeof(TestEnum), row["Enum"]), _testTypeInstance.Enum);
        }

        [Then(@"the following row should be equivalent to the instance when nulls and strings are not to be treated as equivalent")]
        public void ThenTheFollowingRowShouldBeEquivalentToTheInstanceWhenNullsAndStringsAreNotToBeTreatedAsEquivalent(Table table)
        {
            table.Rows.Single().CompareToInstance(_testTypeInstance);
        }

        [Then(@"the following row should be equivalent to the instance when nulls and strings are to be treated as equivalent")]
        public void ThenTheFollowingRowShouldBeEquivalentToTheInstanceWhenNullsAndStringsAreToBeTreatedAsEquivalent(Table table)
        {
            table.Rows.Single().CompareToInstance(_testTypeInstance, treatEmptyAndNullStringsAsEquivalent: true);
        }

        [Then(@"the following boolean literals should be parsed as True")]
        public void ThenTheFollowingBooleanLiteralsShouldBeParsedAsTrue(Table table)
        {
            table.Rows.ForEach(row =>
            {
                bool? b = row.ParseNullableBoolean("Value");

                Assert.IsNotNull(b);
                Assert.IsTrue(b.Value);
            });
        }

        [Then(@"the following boolean literals should be parsed as False")]
        public void ThenTheFollowingBooleanLiteralsShouldBeParsedAsFalse(Table table)
        {
            table.Rows.ForEach(row =>
            {
                bool? b = row.ParseNullableBoolean("Value");

                Assert.IsNotNull(b);
                Assert.IsFalse(b.Value);
            });
        }

        [Then(@"the following boolean literals should be parsed as NULL")]
        public void ThenTheFollowingBooleanLiteralsShouldBeParsedAsNull(Table table)
        {
            table.Rows.ForEach(row =>
            {
                bool? b = row.ParseNullableBoolean("Value");

                Assert.IsNull(b);
            });
        }

        private class TestType
        {
            public string Prop1 { get; set; }

            public string Prop2 { get; set; }

            public TestEnum Enum { get; set; }
        }

        private enum TestEnum
        {
            FirstEnumValue,
            SecondEnumValue
        }
    }
}
