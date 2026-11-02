namespace XrmMigrator.Common.Entities
{
    using System;

    public class OrganisationDto
    {
        public string OrganisationId { get; set; }
        public string UkPrn { get; set; }

        public Guid? OrganisationCrmId { get; set; }
    }
}
