namespace OrganisationDomain.Implementation.Converters
{
    using System.Collections.Generic;
    using Integration.Entities;

    public interface ICpdsProviderConverter
    {
        string CpdsXml { get; set; }

        List<ProviderSequence> ConvertXmlToProviders();
        
        byte[] ConvertProviderSequenceListToBlob(List<ProviderSequence> summary);
        
        List<ProviderSequence> ConvertBlobToProviderSequenceList(byte[] blob);
    }
}