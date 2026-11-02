namespace ContractCreateDomain.Implementation.Tests.Repositories
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.Implementation.Repositories;

    [TestClass]
    public class SequenceNameTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void SequenceName_ShouldFormatExpectedDatabaseSequenceName()
        {
            // act
            SequenceName sequenceName = new SequenceName(SequenceType.Master, "ESFA");

            // assert
            Assert.AreEqual("Master_ESFA_seq", sequenceName.ToString());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SequenceName_ShouldReplaceIncompatibleCharacters()
        {
            // arrange
            const string contextWithPlusHyphenAndSpace = "16-18 24+LOANS";

            // act
            SequenceName sequenceName = new SequenceName(SequenceType.Contract, contextWithPlusHyphenAndSpace);

            // assert
            Assert.AreEqual("Contract_16_hyphen_1824_plus_LOANS_seq", sequenceName.ToString());
        }
    }
}
