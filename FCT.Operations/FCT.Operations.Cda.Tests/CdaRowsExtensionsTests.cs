namespace FCT.Operations.Cda.Tests
{
    using System.Collections.Generic;
    using Extensions;
    using FCT.Operations.Cda.Dtos;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class CdaRowsExtensionsTests
    {

        [TestMethod, TestCategory("UnitTest")]
        public void CdaRowsExtensionsTest_SplitToOpenAndClosed_ShouldSplitToOpenAndClosed()
        {
            // arrange
            const string closedContractNumber1 = "MAIN-456";
            const string closedContractNumber2 = "MAIN-457";
            const string closedContractNumber3 = "MAIN-156";
            const string closedContractNumber4 = "MAIN-157";

            List<CdaRow> rows = new List<CdaRow>
            {
                new CdaRow
                {
                    ContractNumber = "MAIN-458"
                },
                new CdaRow
                {
                    ContractNumber = "MAIN-458"
                },
                new CdaRow
                {
                    ContractNumber = "MAIN-789"
                },
                new CdaRow
                {   
                    ContractNumber = closedContractNumber1
                },
                new CdaRow
                {
                    ContractNumber = closedContractNumber2
                },
                new CdaRow
                {
                    ContractNumber = closedContractNumber3
                },
                new CdaRow
                {
                    ContractNumber = closedContractNumber4
                }
            };

            List<(string contractNumber, int year)> closedContractWithYearItems =
                new List<(string contractNumber, int year)>
                {
                    (closedContractNumber1, 2021),
                    (closedContractNumber2, 2021),
                    (closedContractNumber3, 2020),
                    (closedContractNumber4, 2020)
                };
            // act
            var openAndClosedRows = rows.SplitToOpenAndClosed(closedContractWithYearItems);

            // assert
            openAndClosedRows.ClosedYears.Count.Should().Be(2);
            openAndClosedRows.OpenContractRows.Count.Should().Be(3);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CdaRowsExtensionsTest_SplitToOpenAndClosed_ShouldOnlyReturnClosedYearsThatHaveRows()
        {
            // arrange
            const string closedContractNumber1 = "MAIN-456";
            const string closedContractNumber2 = "MAIN-457";
            const string closedContractNumber3 = "MAIN-156";
            const string closedContractNumber4 = "MAIN-157";

            List<CdaRow> rows = new List<CdaRow>
            {
                new CdaRow
                {
                    ContractNumber = "MAIN-458"
                },
                new CdaRow
                {
                    ContractNumber = "MAIN-458"
                },
                new CdaRow
                {
                    ContractNumber = "MAIN-789"
                },
                new CdaRow
                {
                    ContractNumber = closedContractNumber1
                },
                new CdaRow
                {
                    ContractNumber = closedContractNumber2
                },
                new CdaRow
                {
                    ContractNumber = closedContractNumber2
                },
                new CdaRow
                {
                    ContractNumber = closedContractNumber2
                }
            };

            List<(string contractNumber, int year)> closedContractWithYearItems =
                new List<(string contractNumber, int year)>
                {
                    (closedContractNumber1, 2021),
                    (closedContractNumber2, 2021),
                    (closedContractNumber3, 2020),
                    (closedContractNumber4, 2020)
                };
            // act
            var openAndClosedRows = rows.SplitToOpenAndClosed(closedContractWithYearItems);

            // assert
            openAndClosedRows.ClosedYears.Count.Should().Be(1);
            openAndClosedRows.OpenContractRows.Count.Should().Be(3);
        }
    }
}
