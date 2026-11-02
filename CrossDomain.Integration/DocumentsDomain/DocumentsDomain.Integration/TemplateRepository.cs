namespace SFA.FCT.DocumentsDomain.Integration
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using Common.Models;
    using Aspose.Words;
    using Framework.Logging.Interfaces;
    using Framework.Logging.NullObjects;

    public class TemplateRepository : ITemplateRepository
    {
        private readonly IAzureStorageWrapper _azureStorageWrapper;
        private readonly Dictionary<string, Dictionary<string, byte[]>> _templateCache;
        private readonly object _templateCachePadlock = new object();

        public TemplateRepository(IAzureStorageWrapper azureStorageWrapper)
        {
            _azureStorageWrapper = azureStorageWrapper;
            _templateCache = new Dictionary<string, Dictionary<string, byte[]>>();
            Logger = new LoggerNullObject();
        }

        public ILogger Logger { get; set; }

        public Document GetTemplate(FctFile file)
        {
            if (!_templateCache.ContainsKey(file.FileContainer))
            {
                _templateCache.Add(file.FileContainer, new Dictionary<string, byte[]>());
            }

            if (!_templateCache[file.FileContainer].ContainsKey(file.Filename))
            {
                lock (_templateCachePadlock)
                {
                    if (!_templateCache[file.FileContainer].ContainsKey(file.Filename))
                    {
                _templateCache[file.FileContainer].Add(file.Filename, _azureStorageWrapper.GetBlockBlobContents(file));
            }
                }
            }

            Document templateDocument = null;
            using (MemoryStream stream = new MemoryStream(_templateCache[file.FileContainer][file.Filename]))
            {
                templateDocument = new Document(stream);
            }

            return templateDocument;
        }

        public bool CheckTemplateExists(FctFile file)
        {
            return (_templateCache.ContainsKey(file.FileContainer) && _templateCache[file.FileContainer].ContainsKey(file.Filename))
                   || _azureStorageWrapper.DoesBlockBlobExist(file);
        }

        public string[] GetTemplateNames(string containerName)
        {
            return _azureStorageWrapper.GetContainerContents(containerName);
        }

        public string GetNameOfTemplateActiveOnDate(string containerName, string startsWith, DateTime contractStartDate)
        {
            try
            {
                string[] templateNames = GetTemplateNames(containerName);

                string date = contractStartDate.ToString("yyyy-MM-dd");

                string activeTemplate =
                    templateNames
                        .Where(t => t.StartsWith(startsWith) && (t.CompareTo(startsWith + "_" + date + ".docx") <= 0))
                        .OrderByDescending(t => t)
                        .First();

                return activeTemplate;
            }
            catch (Exception ex)
            {
                throw new FileNotFoundException(
                    string.Format(
                        "Template matching request not found in '{0}' using prefix '{1}' with startDate '{2:yyyy-MM-dd}'",
                        containerName,
                        startsWith,
                        contractStartDate),
                    ex);
            }
        }
    }
}
