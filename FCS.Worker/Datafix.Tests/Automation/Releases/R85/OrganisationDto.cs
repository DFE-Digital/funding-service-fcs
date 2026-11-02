namespace Datafix.Tests.Automation.Releases.R85
{
    using System;

    public class OrganisationDto
    {
        public OrganisationDto() 
        { }

        public OrganisationDto(int organisationId, int ukprn, int upin, int sequenceNumber, string tradingName, DateTime createdDate, string companyRegistrationNumber, bool hasUkrlpBeenCalledSuccessfully, string charityNumber, string status, string type, string addressLine1, string addressLine2, string addressLine3, string addressLine4, string addressTown, string addressCounty, string addressPostcode)
        {
            OrganisationId = organisationId;
            Ukprn = ukprn;
            Upin = upin;
            SequenceNumber = sequenceNumber;
            TradingName = tradingName;
            CreatedDate = createdDate;
            CompanyRegistrationNumber = companyRegistrationNumber;
            HasUkrlpBeenCalledSuccessfully = hasUkrlpBeenCalledSuccessfully;
            CharityNumber = charityNumber;
            Status = status;
            Type = type;
            Address_Line1 = addressLine1;
            Address_Line2 = addressLine2;
            Address_Line3 = addressLine3;
            Address_Line4 = addressLine4;
            Address_Town = addressTown;
            Address_County = addressCounty;
            Address_Postcode = addressPostcode;
        }

        public int OrganisationId { get; }

        public int Ukprn { get; }

        public int Upin { get; }

        public int SequenceNumber { get; }

        public string TradingName { get; }

        public DateTime CreatedDate { get; }

        public string CompanyRegistrationNumber { get; }
        
        public bool HasUkrlpBeenCalledSuccessfully { get; }

        public string CharityNumber { get; }

        public string Status { get; }

        public string Type { get; }

        public string Address_Line1 { get; }

        public string Address_Line2 { get; }

        public string Address_Line3 { get; }

        public string Address_Line4 { get; }

        public string Address_Town { get; }

        public string Address_County { get; }

        public string Address_Postcode { get; }
    }
}