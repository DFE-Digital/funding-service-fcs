namespace FCT.Console.Config.Tests.Infrastructure
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using Config.Infrastructure;
    using Config.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass]
    public class MissingSequenceCreatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void MissingSequenceCreator_ShouldCallToGetCurrentValFromCrm_IfSeqMissing()
        {
            // arrange
            List<SequenceNameInfo> expectedSequences = new List<SequenceNameInfo>
            {
                new SequenceNameInfo("master_esfa_seq", "esfa")
            };
            List<string> existingSeqeunces = new List<string>();
            bool calledCreateSeq = false;
            Action<string, int> createSequence = (s, i) => calledCreateSeq = true;
            Mock<ICrmContractNumberRepository> crmContractNumberRepositoryMock = new Mock<ICrmContractNumberRepository>();

            // act
            MissingSequenceCreator.CreateMissingSequences(expectedSequences, createSequence, existingSeqeunces, ContractNumberType.Master, crmContractNumberRepositoryMock.Object);
            
            // assert
            crmContractNumberRepositoryMock.Verify(r => r.GetCurrentContractNumber(ContractNumberType.Master, "esfa"), Times.Once, "We have not asked crm for a number");
            Assert.AreEqual(true, calledCreateSeq, "We have not called Create Sequence");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MissingSequenceCreator_CreateSequenceNameInfo_ShouldReplaceHyphenWithHyphenText()
        {
            // arrange and act
            string sequenceName = MissingSequenceCreator.CreateSequenceNameInfo(ContractNumberType.Allocation, "AEBTO-LS").SequenceName;

            // assert
            Assert.AreEqual("Allocation_AEBTO_hyphen_LS_seq", sequenceName);
        }
    }
}
