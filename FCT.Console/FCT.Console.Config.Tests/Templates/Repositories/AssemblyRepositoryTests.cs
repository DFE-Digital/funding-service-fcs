namespace FCT.Console.Config.Tests.Repositories.Repositories
{
    using FCT.Console.Config.Templates.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Linq;

    [TestClass]
    public class AssemblyRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AssemblyRepository_GetFilenamesToUpload_ShouldReturnsAListOfFilenames()
        {
            // arrange
            var assemblyRepository = new AssemblyRepository();

            // act 
            var fileNames = assemblyRepository.GetFilenamesToUpload();

            // assert
            Assert.IsTrue(fileNames.ToList().Count > 0, "Filenames were not returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AssemblyRepository_GetTemplateDocumentToUpload_ShouldReturnAFile()
        {
            // arrange
            var assemblyRepository = new AssemblyRepository();
            var fileName = assemblyRepository.GetFilenamesToUpload().First();

            // act 
            var file = assemblyRepository.GetTemplateDocumentToUpload(fileName);

            // assert
            Assert.IsNotNull(file, "File was not returned");
        }
    }
}