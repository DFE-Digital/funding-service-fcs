namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.DocumentsDomain.Common.Models;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner;
    using System.Linq;
    using Common;
    using DataStore.Repositories;

    [TestClass]
    public class DocumentDefinerTest
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DocGen_DocumentDefiner_GetsDocumentParts()
        {
            Mock<DocumentPartCreator> docCreatorMock =  new Mock<DocumentPartCreator>(null, null);
            docCreatorMock.Setup(m => m.IsDocumentPartRequired(It.IsAny<contractType>())).Returns(true);
            docCreatorMock.Setup(m => m.SupplyDocumentGenerationRequest(It.IsAny<string>(), It.IsAny<contractType>(), It.IsAny<string>())).Returns(new Dictionary<string, DocumentGenerationRequest>()
            {
                {"100", new DocumentGenerationRequest()
                    {
                        TemplateContainer = "test-template-container",
                        TemplateFilename = "test-template-filename",
                        MergeData = null
                    }
                }    
            });
            docCreatorMock.Setup(m => m.IsHeaderDocumentRequired).Returns(false);

            Mock<IDocumentPartFinder> partFinderMock = new Mock<IDocumentPartFinder>();
            partFinderMock.Setup(m => m.GetDocumentPartCreators(It.IsAny<contractType>())).Returns(new DocumentPartCreator[]{docCreatorMock.Object});


            IDocumentDefiner docDefiner = new DocumentDefiner(partFinderMock.Object);
            DocumentGenerationRequest[] request = docDefiner.GetDocumentParts(null, null);


            docCreatorMock.Verify(m=>m.IsDocumentPartRequired(It.IsAny<contractType>()), Times.Once);
            docCreatorMock.Verify(m => m.SupplyDocumentGenerationRequest(It.IsAny<string>(), It.IsAny<contractType>(),  It.IsAny<string>()), Times.Once);
            docCreatorMock.Verify(m=>m.IsHeaderDocumentRequired, Times.Once);
            docCreatorMock.Verify(m=>m.RequiredHeaderDocumentName, Times.Never);

            Assert.AreEqual(request.Length, 1);

            Assert.AreEqual("test-template-container", request[0].TemplateContainer);
            Assert.AreEqual("test-template-filename", request[0].TemplateFilename);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocGen_DocumentDefiner_GetsMultipleDocumentParts()
        {
            Mock<DocumentPartCreator> docCreatorMock =  new Mock<DocumentPartCreator>(null, null);
            docCreatorMock.Setup(m => m.IsDocumentPartRequired(It.IsAny<contractType>())).Returns(true);
            docCreatorMock.Setup(m => m.SupplyDocumentGenerationRequest(It.IsAny<string>(), It.IsAny<contractType>(), It.IsAny<string>())).Returns(new Dictionary<string, DocumentGenerationRequest>()
            {
                {"100", new DocumentGenerationRequest()
                    {
                        TemplateContainer = "test-template-container",
                        TemplateFilename = "test-template-filename",
                        MergeData = null
                    }
                },
                {"050", new DocumentGenerationRequest()
                    {
                        TemplateContainer = "test-template-container2",
                        TemplateFilename = "test-template-filename2",
                        MergeData = null
                    }
                }

            });
            docCreatorMock.Setup(m => m.IsHeaderDocumentRequired).Returns(false);

            Mock<IDocumentPartFinder> partFinderMock = new Mock<IDocumentPartFinder>();
            partFinderMock.Setup(m => m.GetDocumentPartCreators(It.IsAny<contractType>())).Returns(new DocumentPartCreator[] { docCreatorMock.Object });


            IDocumentDefiner docDefiner = new DocumentDefiner(partFinderMock.Object);
            DocumentGenerationRequest[] request = docDefiner.GetDocumentParts(null, null);


            docCreatorMock.Verify(m => m.IsDocumentPartRequired(It.IsAny<contractType>()), Times.Once);
            docCreatorMock.Verify(m => m.SupplyDocumentGenerationRequest(It.IsAny<string>(), It.IsAny<contractType>(), It.IsAny<string>()), Times.Once);
            docCreatorMock.Verify(m => m.IsHeaderDocumentRequired, Times.Once);
            docCreatorMock.Verify(m => m.RequiredHeaderDocumentName, Times.Never);

            Assert.AreEqual(request.Length, 2, "Incorrect number of parts returned");

            Assert.AreEqual("test-template-container2", request[0].TemplateContainer);
            Assert.AreEqual("test-template-filename2", request[0].TemplateFilename);
            Assert.AreEqual("test-template-container", request[1].TemplateContainer);
            Assert.AreEqual("test-template-filename", request[1].TemplateFilename);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocGen_DocumentDefiner_GetDocumentPartsWithMultiplePartsandHeader()
        {
            // Arrange
            Mock<DocumentPartCreator> docCreatorMock = new Mock<DocumentPartCreator>(null, null);
            docCreatorMock.Setup(m => m.IsDocumentPartRequired(It.IsAny<contractType>())).Returns(true);
            docCreatorMock
                .Setup(m => m.SupplyDocumentGenerationRequest(It.IsAny<string>(), It.IsAny<contractType>(), It.IsAny<string>()))
                .Returns(new Dictionary<string, DocumentGenerationRequest>()
            {
                {"100", new DocumentGenerationRequest()
                    {
                        TemplateContainer = "test-template-container",
                        TemplateFilename = "test-template-filename",
                        MergeData = null
                    }
                }
            });
            docCreatorMock.Setup(m => m.IsHeaderDocumentRequired).Returns(true);
            docCreatorMock.Setup(m => m.RequiredHeaderDocumentName).Returns("headerdocname");

            Mock<IDocumentHeaderCreator> docHeaderMock = new Mock<IDocumentHeaderCreator>();
            docHeaderMock.Setup(m => m.CanSupplyHeader(It.IsAny<string>())).Returns(true);
            docHeaderMock
                .Setup(m => m.SupplyDocumentGenerationRequest(It.IsAny<string>(), It.IsAny<contractType>(), It.IsAny<string>()))
                .Returns(new Tuple<string, DocumentGenerationRequest>("101", new DocumentGenerationRequest()
                {
                    TemplateContainer = "test-template-container",
                    TemplateFilename = "test-template-filenameheader",
                    MergeData = null
                }));


            Mock<IDocumentPartFinder> partFinderMock = new Mock<IDocumentPartFinder>();
            partFinderMock.Setup(m => m.GetDocumentPartCreators(It.IsAny<contractType>())).Returns(new DocumentPartCreator[] { docCreatorMock.Object });
            partFinderMock.Setup(m => m.GetDocumentHeaderCreators()).Returns(new IDocumentHeaderCreator[] { docHeaderMock.Object });

            IDocumentDefiner docDefiner = new DocumentDefiner(partFinderMock.Object);

            // Act
            DocumentGenerationRequest[] request = docDefiner.GetDocumentParts(null, null);

            // Assert
            docCreatorMock.Verify(m => m.IsDocumentPartRequired(It.IsAny<contractType>()), Times.Once);
            docCreatorMock.Verify(m => m.SupplyDocumentGenerationRequest(It.IsAny<string>(), It.IsAny<contractType>(), It.IsAny<string>()), Times.Once);
            docCreatorMock.Verify(m => m.IsHeaderDocumentRequired, Times.Once);
            docCreatorMock.Verify(m => m.RequiredHeaderDocumentName, Times.Once);

            Assert.AreEqual(request.Length, 2, "Incorrect number of parts returned");

            Assert.AreEqual("test-template-container", request[0].TemplateContainer);
            Assert.AreEqual("test-template-filename", request[0].TemplateFilename);
            Assert.AreEqual("test-template-container", request[1].TemplateContainer);
            Assert.AreEqual("test-template-filenameheader", request[1].TemplateFilename);
        }



        [TestMethod, TestCategory("UnitTest")]
        public void DocGen_DocumentDefiner_GetsTargetFile()
        {
            var contract = new contract()
            {
                contractNumber = "Main-1234",
                hierarchyType = hierarchyType.CONTRACT,
                contractVersionNumber = 1,
                contractor = new contractor()
                {
                    ukprn = 78238
                }
            };

            var docDefiner = new DocumentDefiner(new DocumentPartFinder());

            var fctfile=docDefiner.GetTargetFileName(contract);

            Assert.AreEqual("78238_Main-1234_v1.pdf", fctfile.Filename);
            Assert.AreEqual(ConfigurationManager.AppSettings["DocumentGeneration.TargetContainer"], fctfile.FileContainer);

        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocGen_RepeatingSectionType_TestRemoveZerosFromFields_SuccessfullyRemovesZeros()
        {
            string groupName = "Group";
            string nameOfMergeFieldToBlank = "MF2";
            string controlName = "Cash";
            string controlValue = "0.00";

            // Arrange
            List<RepeatingSectionType> listOfRepeatingSectionType = new List<RepeatingSectionType>()
            {
                new RepeatingSectionType()
                {
                    Name = groupName,
                    Rows = new List<RowType>()
                    {
                        new RowType()
                        {
                            MergeFields = new List<MergeFieldType>()
                            {
                                new MergeFieldType()
                                {
                                    Name = controlName,
                                    Value = controlValue
                                },
                                new MergeFieldType()
                                {
                                    Name = nameOfMergeFieldToBlank,
                                    Value = "0.00"
                                },
                                new MergeFieldType()
                                {
                                    Name = "MF3",
                                    Value = "3.23"
                                }
                            }
                        }
                    }
                }
            };


            // Act
            listOfRepeatingSectionType.ForEach(rp => rp.RemoveZerosFromFields(fieldsToIgnore: new List<string> { Constants.CashFieldName }));

            // Assert
            var affectedRow = listOfRepeatingSectionType.First(rp => rp.Name == groupName).Rows.First().MergeFields.First(mf => mf.Name == nameOfMergeFieldToBlank);
            var unAffectedRow = listOfRepeatingSectionType.First(rp => rp.Name == groupName).Rows.First().MergeFields.First(mf => mf.Name == controlName);
            Assert.IsTrue(affectedRow.Value == String.Empty, "Zero was not replaced with empty string");
            Assert.IsTrue(unAffectedRow.Value == controlValue, "Non Zero Decimal Value was incorrectly replaced with a Space");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocGen_RepeatingSectionType_TestRemoveZerosFromNestedRepeatingSection_SuccessfullyRemovesZeros()
        {
            string groupName = "Group";
            string nestedRepeatedSectionGroupName = "NestedGroupName";
            string nameOfMergeFieldToBlank = "MF2";
            string controlName = "Cash";
            string controlValue = "0.00";

            // Arrange
            List<RepeatingSectionType> listOfRepeatingSectionType = new List<RepeatingSectionType>()
            {
                new RepeatingSectionType()
                {
                    Name = groupName,
                    Rows = new List<RowType>()
                    {
                        new RowType()
                        {
                            MergeFields = new List<MergeFieldType>()
                            {
                                new MergeFieldType()
                                {
                                    Name = controlName,
                                    Value = controlValue
                                },
                                new MergeFieldType()
                                {
                                    Name = "Total",
                                    Value = "232.23"
                                },
                            },
                            RepeatingSection = new RepeatingSectionType()
                            {
                                Name = nestedRepeatedSectionGroupName,
                                Rows = new List<RowType>()
                                {
                                    new RowType()
                                    {
                                        MergeFields = new List<MergeFieldType>()
                                        {
                                            new MergeFieldType()
                                            {
                                                Name = controlName,
                                                Value = controlValue
                                            },
                                            new MergeFieldType()
                                            {
                                                Name = nameOfMergeFieldToBlank,
                                                Value = "0.00"
                                            },
                                            new MergeFieldType()
                                            {
                                                Name = "MF3",
                                                Value = "3.00"
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            };


            // Act
            listOfRepeatingSectionType.ForEach(rp => rp.RemoveZerosFromFields(fieldsToIgnore: new List<string> { Constants.CashFieldName }));

            // Assert
            var affectedRow = listOfRepeatingSectionType.First(rp => rp.Name == groupName).Rows.First().RepeatingSection.Rows.First().MergeFields.First(mf => mf.Name == nameOfMergeFieldToBlank);
            var unAffectedRow = listOfRepeatingSectionType.First(rp => rp.Name == groupName).Rows.First().MergeFields.First(mf => mf.Name == controlName);
            Assert.IsTrue(affectedRow.Value == String.Empty, "Zero was not replaced with empty string");
            Assert.IsTrue(unAffectedRow.Value == controlValue, "Non Zero Decimal Value was incorrectly replaced with a Space");
        }

    }
}
