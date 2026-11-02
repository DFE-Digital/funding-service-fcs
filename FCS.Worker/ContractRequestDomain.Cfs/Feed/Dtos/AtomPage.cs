namespace ContractRequestDomain.Cfs.Feed.Dtos
{
    using System;
    using System.Linq;

    public class AtomPage
    {
        public AtomLink[] Link { get; set; }

        public AtomEntry[] AtomEntry { get; set; }

        public int GetPageNumber()
        {
            const string pageRefParameterFormat = "pageRef=";

            string selfLink = Link.Single(lnk => lnk.Rel == "self").Href;
            int pageNumber = int.Parse(selfLink.Substring(selfLink.LastIndexOf(pageRefParameterFormat, StringComparison.Ordinal) + pageRefParameterFormat.Length));

            return pageNumber;
        }
    }

    public class AtomLink
    {
        public string Href { get; set; }

        public string Rel { get; set; }
    }

    public class AtomEntry
    {
        public string Id { get; set; }

        public AtomContent Content { get; set; }
    }

    public class AtomContent
    {
        public AtomAllocation Allocation { get; set; }
    }

    public class AtomAllocation
    {
        public AtomProvider Provider { get; set; }

        public int AllocationVersionNumber { get; set; }
    }

    public class AtomProvider
    {
        public int UkPrn { get; set; }
    }
}
