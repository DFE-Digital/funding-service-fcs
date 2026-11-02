namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Services
{
    using System;
    using DocumentGeneration.Repositories;
    using DocumentGeneration.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass]
    public class TemplateVersionCheckerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void TemplateVersionChecker_ShouldIncludeTemplate_ShouldReturnTrueWhenNewTemplateAvailable_Variation_LastApprovedCreated()
        {
            // arrange
            DateTime lastApprovedContractCreated = DateTime.Now.AddMonths(-1);
            Mock<IUploadedDocumentTemplateQueryRepository> uploadedDocumentTemplateQueryRepositoryMock = new Mock<IUploadedDocumentTemplateQueryRepository>();
            uploadedDocumentTemplateQueryRepositoryMock.Setup(r => r.GetDateUploaded(It.IsAny<string>()))
                .Returns(DateTime.Now);

            TemplateVersionChecker templateVersionChecker =
                new TemplateVersionChecker(uploadedDocumentTemplateQueryRepositoryMock.Object);

            // act
            bool isNewTemplateAvailable = templateVersionChecker.ShouldIncludeTemplate("some template",
                lastApprovedContractCreated, true);

            // assert
            Assert.IsTrue(isNewTemplateAvailable);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TemplateVersionChecker_ShouldIncludeTemplate_ShouldReturnTrueWhenNewTemplateAvailableAndNotVariationAndLastApprovedCreated()
        {
            // arrange
            DateTime lastApprovedContractCreated = DateTime.Now.AddMonths(-1);
            Mock<IUploadedDocumentTemplateQueryRepository> uploadedDocumentTemplateQueryRepositoryMock = new Mock<IUploadedDocumentTemplateQueryRepository>();
            uploadedDocumentTemplateQueryRepositoryMock.Setup(r => r.GetDateUploaded(It.IsAny<string>()))
                .Returns(DateTime.Now);

            TemplateVersionChecker templateVersionChecker =
                new TemplateVersionChecker(uploadedDocumentTemplateQueryRepositoryMock.Object);

            // act
            bool isNewTemplateAvailable = templateVersionChecker.ShouldIncludeTemplate("some template",
                lastApprovedContractCreated, false);

            // assert
            Assert.IsTrue(isNewTemplateAvailable);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TemplateVersionChecker_ShouldIncludeTemplate_ShouldReturnFalseWhenNewTemplateNotAvailableAndVariationAndLastApprovedCreated()
        {
            // arrange
            DateTime lastApprovedContractCreated = DateTime.Now.AddMonths(-1);
            Mock<IUploadedDocumentTemplateQueryRepository> uploadedDocumentTemplateQueryRepositoryMock = new Mock<IUploadedDocumentTemplateQueryRepository>();
            uploadedDocumentTemplateQueryRepositoryMock.Setup(r => r.GetDateUploaded(It.IsAny<string>()))
                .Returns(DateTime.Now.AddMonths(-2));

            TemplateVersionChecker templateVersionChecker =
                new TemplateVersionChecker(uploadedDocumentTemplateQueryRepositoryMock.Object);

            // act
            bool isNewTemplateAvailable = templateVersionChecker.ShouldIncludeTemplate("some template",
                lastApprovedContractCreated, true);

            // assert
            Assert.IsFalse(isNewTemplateAvailable);
        }
    }
}
