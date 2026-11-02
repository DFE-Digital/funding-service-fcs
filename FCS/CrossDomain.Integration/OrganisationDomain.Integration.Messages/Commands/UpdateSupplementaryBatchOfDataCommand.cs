namespace OrganisationDomain.Integration.Messages.Commands
{
    using System.Collections.Generic;
    using Dtos;

    public class UpdateSupplementaryBatchOfDataCommand
    {
        public IEnumerable<OrgSupplementaryDataDto> OrgSupplementaryDataCollection { get; set; }
    }
}
