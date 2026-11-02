namespace DocumentsDomain.Endpoint.ArchiveDocument.Services
{
    public static class DocumentFolderLocation
    {
        public static string GetLocationOfAppendices(string fundingTypeCode, string period)
        {
            return $"{fundingTypeCode}-{period}-Input-Appendices";
        }

        public static string GetLocationOfPublishedDocument(string fundingTypeCode, string period)
        {
            return $"{fundingTypeCode}-{period}-Output-Documents for Publication";
        }
    }
}
