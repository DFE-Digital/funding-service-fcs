namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentCreator
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using Aspose.Words;
    using Common.Models;
    using Integration;
    using Common;
    using Framework.Logging.NullObjects;
    using Framework.Logging.Interfaces;

    public class DocumentCreator : IDocumentCreator
    {
        private readonly IAsposeWrapper _asposeWrapper;
        private readonly ITemplateRepository _templateRepository;

        public DocumentCreator(IAsposeWrapper asposeWrapper, ITemplateRepository templateRepository)
        {
            _asposeWrapper = asposeWrapper;
            _templateRepository = templateRepository;
            Logger = new LoggerNullObject();
        }

        public ILogger Logger { get; set; }

        public Document CreateDocument(DocumentGenerationRequest createRequest)
        {
            Document templateDoc;
            try
            {
                templateDoc = _templateRepository.GetTemplate(new FctFile(createRequest.TemplateContainer, createRequest.TemplateFilename));
            }
            catch (Exception ex)
            {
                throw new FileNotFoundException(string.Format("Template file not found: {0}:{1}", createRequest.TemplateContainer, createRequest.TemplateFilename), ex);
            }

            if (templateDoc == null)
            {
                throw new FileNotFoundException(
                    string.Format("Requested template file not found: Container:'{0}' Filename:'{1}'", createRequest.TemplateContainer, createRequest.TemplateFilename));
            }

            var simpleMergeFields = AddSimpleMergeFields(createRequest.MergeData.MergeFields);
            MergeDataSource[] mergeDataSources = createRequest.MergeData.RepeatingSections?.Select(ToMergeDataSource).ToArray();

            var docPart = _asposeWrapper.Generate(templateDoc, simpleMergeFields, mergeDataSources, createRequest.IndentMarkersOverride);

            return docPart;            
        }

        private List<KeyValuePair<string, object>> AddSimpleMergeFields(IEnumerable<MergeFieldType> mergeFields)
        {
            return mergeFields == null ? new List<KeyValuePair<string, object>>() : mergeFields.Select(mf => new KeyValuePair<string, object>(mf.Name, mf.Value)).ToList();
        }

        private MergeDataSource ToMergeDataSource(RepeatingSectionType repeatingSection)
        {
            MergeDataSource mergeDataSource = new MergeDataSource(repeatingSection.Name ?? Constants.TemplateMainTableName);

            int allocationRowCount = 0;

            foreach (RowType row in repeatingSection.Rows.Where(r => r != null && r.MergeFields != null))
            {
                foreach (MergeFieldType mergeField in row.MergeFields)
                {
                    mergeDataSource.AddRegionMergeField(0, repeatingSection.Name, allocationRowCount, mergeField.Name, mergeField.Value);
                }

                if (row.RepeatingSection != null && row.RepeatingSection.Rows != null &&
                    row.RepeatingSection.Rows.Count > 0)
                {
                    int deliverableRowCount = 0;
                    foreach (RowType deliverableRow in row.RepeatingSection.Rows)
                    {
                        foreach (MergeFieldType deliverableMergeField in deliverableRow.MergeFields)
                        {
                            mergeDataSource.AddRegionMergeField(
                                allocationRowCount,
                                row.RepeatingSection.Name,
                                deliverableRowCount,
                                deliverableMergeField.Name,
                                deliverableMergeField.Value);
                        }

                        deliverableRowCount++;
                    }
                }

                allocationRowCount++;
            }

            return mergeDataSource;
        }
    }
}
