using System.Collections.Generic;
using System.IO;
using Aspose.Words;
using Aspose.Words.Tables;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using SFA.FCT.DocumentsDomain.Common.Models;
using SFA.FCT.DocumentsDomain.DocumentGeneration;
using SFA.FCT.DocumentsDomain.Integration;
using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentCreator;

namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    [TestClass]
    public class DocumentCreatorTest
    {

        [TestMethod]
        [TestCategory("UnitTest")]        public void DocumentCreator_ThrowsAnException_WhenTemplateNotFound()
        {
            // Arrange
            var templateRepositoryMock = new Mock<ITemplateRepository>();
            var asposeWrapperMock = new Mock<IAsposeWrapper>();

            templateRepositoryMock
                .Setup(m => m.GetTemplate(It.IsAny<FctFile>()))
                .Throws<FileNotFoundException>();

            var dgr = new DocumentGenerationRequest
            {
                TemplateContainer = "testcontainer",
                TemplateFilename = "testfilename"
            };

            var docCreator = new DocumentCreator.DocumentCreator(asposeWrapperMock.Object, templateRepositoryMock.Object);

            // Act
            var ex = Assert.ThrowsExactly<FileNotFoundException>(() =>
                docCreator.CreateDocument(dgr));

            // Assert (optional: message)
            StringAssert.Contains(ex.Message, "Requested template file not found");
            StringAssert.Contains(ex.Message, "testcontainer");
            StringAssert.Contains(ex.Message, "testfilename");
        }


        [TestMethod, TestCategory("UnitTest")]
        public void DocumentCreator_HandlesRequestWithNoMergeFields()
        {
            // Arrange
            Mock<ITemplateRepository> templateRepositoryMock = new Mock<ITemplateRepository>();
            Mock<IAsposeWrapper> asposeWrapperMock = new Mock<IAsposeWrapper>();

            templateRepositoryMock.Setup(m => m.GetTemplate(It.IsAny<FctFile>())).Returns(new Document());
            asposeWrapperMock.Setup(m => m.Generate(It.IsAny<Document>(), It.IsAny<List<KeyValuePair<string, object>>>(), It.IsAny<MergeDataSource[]>(), null)).Returns(new Document());

            DocumentGenerationRequest dgr = new DocumentGenerationRequest();
            dgr.TemplateContainer = "testcontainer";
            dgr.TemplateFilename = "testfilename";
            dgr.MergeData = new DocumentGenerationRequestMergeData()
            {
                MergeFields = null,
                RepeatingSections = null
            };

            // Act
            IDocumentCreator docCreator = new DocumentCreator.DocumentCreator(asposeWrapperMock.Object, templateRepositoryMock.Object);
            docCreator.CreateDocument(dgr);

            // Assert
            // Exception should be raised and checked with the method attribute setting

        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentCreator_CreatesADocumentWithSimpleMergeFields()
        {
            // Arrange
            Mock<ITemplateRepository> templateRepositoryMock = new Mock<ITemplateRepository>();
            Mock<IAsposeWrapper> asposeWrapperMock = new Mock<IAsposeWrapper>();

            templateRepositoryMock.Setup(m => m.GetTemplate(It.IsAny<FctFile>())).Returns(new Document()).Verifiable();
            asposeWrapperMock.Setup(m => m.Generate(It.IsAny<Document>(), It.IsAny<List<KeyValuePair<string, object>>>(), It.IsAny<MergeDataSource[]>(), null)).Returns(new Document()).Verifiable();

             DocumentGenerationRequest dgr = new DocumentGenerationRequest();
            dgr.TemplateContainer = "testcontainer";
            dgr.TemplateFilename = "testfilename";
            dgr.MergeData = new DocumentGenerationRequestMergeData();
            dgr.MergeData.MergeFields = new List<MergeFieldType>();
            MergeFieldType mergeFieldType = new MergeFieldType() {Name = "Field1", Value = "Value1"};
            dgr.MergeData.MergeFields.Add(mergeFieldType);
            dgr.MergeData.RepeatingSections = null; 

            // Act
            IDocumentCreator docCreator = new DocumentCreator.DocumentCreator(asposeWrapperMock.Object, templateRepositoryMock.Object);
            Document document = docCreator.CreateDocument(dgr);

            // Assert

            asposeWrapperMock.Verify(m => m.Generate(It.IsAny<Document>(), It.IsAny<List<KeyValuePair<string, object>>>(), It.IsAny<MergeDataSource[]>(), null), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentCreator_CreatesADocument_WithRegion()
        {
            // Arrange
            Mock<ITemplateRepository> templateRepositoryMock = new Mock<ITemplateRepository>();
            Mock<IAsposeWrapper> asposeWrapperMock = new Mock<IAsposeWrapper>();

            templateRepositoryMock.Setup(m => m.GetTemplate(It.IsAny<FctFile>())).Returns(new Document()).Verifiable();
            asposeWrapperMock.Setup(m => m.Generate(It.IsAny<Document>(), It.IsAny<List<KeyValuePair<string, object>>>(), It.IsAny<MergeDataSource[]>(), null)).Returns(new Document()).Verifiable();

            DocumentGenerationRequest dgr = new DocumentGenerationRequest();
            dgr.TemplateContainer = "testcontainer";
            dgr.TemplateFilename = "testfilename";
            dgr.MergeData = new DocumentGenerationRequestMergeData();
            dgr.MergeData.MergeFields = null;
            dgr.MergeData.RepeatingSections = new List<RepeatingSectionType>();
            RepeatingSectionType section = new RepeatingSectionType();
            section.Name = "MainTable";
            section.Rows = new List<RowType>();
            RowType row = new RowType();
            MergeFieldType mergeFieldType = new MergeFieldType() { Name = "Field1", Value = "Value1" };
            row.MergeFields = new List<MergeFieldType>();
            row.MergeFields.Add(mergeFieldType);
            section.Rows.Add(row);
            dgr.MergeData.RepeatingSections.Add(section);
            
            // Act
            IDocumentCreator docCreator = new DocumentCreator.DocumentCreator(asposeWrapperMock.Object, templateRepositoryMock.Object);
            Document document = docCreator.CreateDocument(dgr);

            // Assert

            asposeWrapperMock.Verify(m => m.Generate(It.IsAny<Document>(), It.IsAny<List<KeyValuePair<string, object>>>(), It.IsAny<MergeDataSource[]>(), null), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentCreator_CreatesADocument_WithRegionAndSubRegion()
        {
            // Arrange
            Mock<ITemplateRepository> templateRepositoryMock = new Mock<ITemplateRepository>();
            Mock<IAsposeWrapper> asposeWrapperMock = new Mock<IAsposeWrapper>();

            templateRepositoryMock.Setup(m => m.GetTemplate(It.IsAny<FctFile>())).Returns(new Document()).Verifiable();
            asposeWrapperMock.Setup(m => m.Generate(It.IsAny<Document>(), It.IsAny<List<KeyValuePair<string, object>>>(), It.IsAny<MergeDataSource[]>(), null)).Returns(new Document()).Verifiable();

            DocumentGenerationRequest dgr = new DocumentGenerationRequest();
            dgr.TemplateContainer = "testcontainer";
            dgr.TemplateFilename = "testfilename";
            dgr.MergeData = new DocumentGenerationRequestMergeData();
            dgr.MergeData.MergeFields = null;
            dgr.MergeData.RepeatingSections = new List<RepeatingSectionType>();
            RepeatingSectionType section = new RepeatingSectionType();
            section.Name = "MainTable";
            section.Rows = new List<RowType>();
            RowType row = new RowType();
            MergeFieldType mergeFieldType = new MergeFieldType() { Name = "Field1", Value = "Value1" };
            row.MergeFields = new List<MergeFieldType>();
            row.MergeFields.Add(mergeFieldType);
            row.RepeatingSection = new RepeatingSectionType("Section1");
            row.RepeatingSection.Rows = new List<RowType>();
            RowType repeatingSectionRowType = new RowType();
            repeatingSectionRowType.MergeFields = new List<MergeFieldType>();
            MergeFieldType repeatingSectionMergeFieldType = new MergeFieldType() { Name = "Field1", Value = "Value1" };
            repeatingSectionRowType.MergeFields.Add(repeatingSectionMergeFieldType);
            row.RepeatingSection.Rows.Add(repeatingSectionRowType);

            section.Rows.Add(row);
            dgr.MergeData.RepeatingSections.Add(section);

            // Act
            IDocumentCreator docCreator = new DocumentCreator.DocumentCreator(asposeWrapperMock.Object, templateRepositoryMock.Object);
            Document document = docCreator.CreateDocument(dgr);

            // Assert

            asposeWrapperMock.Verify(m => m.Generate(It.IsAny<Document>(), It.IsAny<List<KeyValuePair<string, object>>>(), It.IsAny<MergeDataSource[]>(), null), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentCreator_CreatesADocument_WithRepeatingSectionsWithNullOrEmptyMergeFields()
        {
            Mock<ITemplateRepository> templateRepositoryMock = new Mock<ITemplateRepository>();
            templateRepositoryMock
                .Setup(m => m.GetTemplate(It.IsAny<FctFile>()))
                .Returns(new Document())
                .Verifiable();

            Mock<IAsposeWrapper> asposeWrapperMock = new Mock<IAsposeWrapper>();

            asposeWrapperMock
                .Setup(m => m.Generate(It.IsAny<Document>(), It.IsAny<List<KeyValuePair<string, object>>>(), It.IsAny<MergeDataSource[]>(), null)).Returns(new Document())
                .Verifiable();

            DocumentGenerationRequest dgr = new DocumentGenerationRequest()
            {
                TemplateContainer = "testcontainer",
                TemplateFilename = "testfilename",
                MergeData = new DocumentGenerationRequestMergeData()
                {
                    MergeFields = null,
                    RepeatingSections = new List<RepeatingSectionType>()
                    {
                        new RepeatingSectionType()
                        {
                            Name = "MainTable",
                            Rows = new List<RowType>()
                            {
                                (RowType)null
                            }
                        },
                        new RepeatingSectionType()
                        {
                            Name = "MainTable",
                            Rows = new List<RowType>()
                            {
                                new RowType()
                                {
                                    MergeFields = null,
                                    RepeatingSection = new RepeatingSectionType()
                                    {
                                        Rows = new List<RowType>()   
                                    }                                    
                                }
                            }
                        },
                        new RepeatingSectionType()
                        {
                            Name = "MainTable",
                            Rows = new List<RowType>()
                            {
                                new RowType()
                                {
                                    MergeFields = new List<MergeFieldType>(),
                                    RepeatingSection = null                           
                                }
                            }
                        },
                        new RepeatingSectionType()
                        {
                            Name = "MainTable",
                            Rows = new List<RowType>()
                            {
                                new RowType()
                                {
                                    MergeFields = new List<MergeFieldType>(),
                                    RepeatingSection = new RepeatingSectionType()
                                    {
                                        Rows = null
                                    }
                                }
                            }
                        },
                        new RepeatingSectionType()
                        {
                            Name = "MainTable",
                            Rows = new List<RowType>()
                            {
                                new RowType()
                                {
                                    MergeFields = new List<MergeFieldType>(),
                                    RepeatingSection = new RepeatingSectionType()
                                    {
                                        Rows = new List<RowType>()
                                    }
                                }
                            }
                        }
                        
                    }
                }
            };



            IDocumentCreator creator = new DocumentCreator.DocumentCreator(asposeWrapperMock.Object, templateRepositoryMock.Object);
            creator.CreateDocument(dgr);

        }
    }
}
