namespace SFA.FCT.DocumentsDomain.Common.Commands
{
    using CrossDomain.Integration.Entities.CorporateContract;

    public class GetDocumentsForDeleteCommand
    { 
        public contractType Contract { get; set; }
    }
}
