namespace SFA.FCT.CrossDomain.Integration.Entities
{
    using System.Collections.Generic;

    [System.Diagnostics.CodeAnalysis.ExcludeFromCodeCoverage]
    public static class ESFFundingStreams
    {
        public static readonly IReadOnlyCollection<string> FundingStreams = new List<string>
        {
            "ESF 201420"
        }.AsReadOnly();
    }
}
