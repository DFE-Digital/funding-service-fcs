using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using SFA.FCT.DocumentsDomain.Common.Models;
using SFA.FCT.DocumentsDomain.Integration;
using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentCreator;
using SFA.FCT.DocumentsDomain.DocumentGeneration;
using Aspose.Words;

namespace SFA.FCT.DocumentsDomain.UnitTests.BusinessLayer
{
    [TestClass]
    public class DocumentCreatorTests
    {
        private IDocumentCreator _documentCreator;
        private Mock<IAsposeWrapper> _mockAsposeWrapper;
        private Mock<ITemplateRepository> _mockTemplateRepository;
        private FctFile _template;
        private DocumentGenerationRequestMergeData _mergeData;
        private DocumentGenerationRequest _docGenRequest = new DocumentGenerationRequest();

        [TestInitialize]
        public void TestInit()
        {
            _mockAsposeWrapper = new Mock<IAsposeWrapper>();
            _mockTemplateRepository = new Mock<ITemplateRepository>();
            _documentCreator = new DocumentCreator(_mockAsposeWrapper.Object, _mockTemplateRepository.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocGen_DocCreatorGeneratesADocument_WhenCalledWithADocGenRequest()
        {
            Arrange();

            Document testOut = _documentCreator.CreateDocument(_docGenRequest);

            // Assert
            Assert.IsNotNull(testOut, "No document returned");
        }

        private void Arrange()
        {
            ArrangeTemplate();
            ArrangeMergeData();

            _mockAsposeWrapper.Setup(m => m.Generate(It.IsAny<Document>(), It.IsAny<List<KeyValuePair<string, object>>>(), It.IsAny<MergeDataSource[]>(), null)).Returns(new Document());
            _mockTemplateRepository.Setup(m => m.GetTemplate(It.IsAny<FctFile>())).Returns(new Document());

            _docGenRequest.TemplateContainer = _template.FileContainer;
            _docGenRequest.TemplateFilename = _template.Filename;
            
        }

        private void ArrangeTemplate()
        {
            _template = new FctFile("document-template-ci", "SummaryOfFunding_Mainstream.docx");
        }

        private void ArrangeMergeData()
        {
            _mergeData = new DocumentGenerationRequestMergeData();
            // Add upper level
            AddMergeFields();
            // Add sections
            AddRepeatingSections();

            _docGenRequest.MergeData = _mergeData;
        }

        private void AddMergeFields()
        {
            _mergeData.MergeFields.Add(CreateMergeField("OrgName", "1342"));
            _mergeData.MergeFields.Add(CreateMergeField("UKPRN", "1342"));
            _mergeData.MergeFields.Add(CreateMergeField("MasterContractRef", "SFA-3456"));

        }

        private void AddRepeatingSections()
        {
            _mergeData.RepeatingSections = new List<RepeatingSectionType>();
            RepeatingSectionType section =
                new RepeatingSectionType
                {
                    Name = "Allocations",
                    Rows = CreateRepeatingSection1Rows()
                };
            _mergeData.RepeatingSections.Add(section);
        }

        private List<RowType> CreateRepeatingSection1Rows()
        {
            var rows = new List<RowType>();
            RowType row = new RowType
            {
                MergeFields = CreateRepeatingSection1Row1MergeFields()
            };
            row.RepeatingSection = CreateDeliverablesSection();
            rows.Add(row);

            row = new RowType
            {
                MergeFields = CreateRepeatingSection1Row2MergeFields()
            };
            rows.Add(row);

            row = new RowType
            {
                MergeFields = CreateRepeatingSection1Row3MergeFields()
            };
            rows.Add(row);

            return rows;
        }

        private List<MergeFieldType> CreateRepeatingSection1Row1MergeFields()
        {
            var mergeFields = new List<MergeFieldType>
            {
                CreateMergeField("AllocationName", "Skills Support for Redundancy"),
                CreateMergeField("AllocationContractRef", "ESF-23"),
                CreateMergeField("AllocationStartDate", "01/08/2015"),
                CreateMergeField("AllocationEndDate", "31/12/2016"),
                CreateMergeField("AllocationTotal", "600000")
            };
            return mergeFields;
        }

        private RepeatingSectionType CreateDeliverablesSection()
        {
            var repeatingSection = new RepeatingSectionType();

            repeatingSection.Name = "Deliverable";
            RowType row = new RowType();
            row.MergeFields = new List<MergeFieldType>
            {
                CreateMergeField("DeliverableName", "Of which 19+ Apprenticeships"),
                CreateMergeField("DeliverableTotal", "10000")
            };
            repeatingSection.Rows.Add(row);

            return repeatingSection;
        }



        private List<MergeFieldType> CreateRepeatingSection1Row2MergeFields()
        {
            List<MergeFieldType> mergeFields = new List<MergeFieldType>
            {
                CreateMergeField("AllocationName", "Skills Support for the Unemployed"),
                CreateMergeField("AllocationContractRef", "ESF-416"),
                CreateMergeField("AllocationStartDate", "01/01/2016"),
                CreateMergeField("AllocationEndDate", "31/07/2016"),
                CreateMergeField("AllocationTotal", "300000")
            };
            return mergeFields;
        }

        private List<MergeFieldType> CreateRepeatingSection1Row3MergeFields()
        {
            List<MergeFieldType> mergeFields = new List<MergeFieldType> { CreateMergeField("ContractTotal", "900000") };
            return mergeFields;
        }

        private MergeFieldType CreateMergeField(string name, string value)
        {
            MergeFieldType mergeField = new MergeFieldType { Name = name, Value = value };
            return mergeField;

        }

    }
}
