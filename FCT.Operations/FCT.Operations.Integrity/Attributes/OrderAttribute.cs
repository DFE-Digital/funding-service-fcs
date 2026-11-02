namespace SFA.FCT.Operations.Integrity.Attributes
{
    using System;

    public class OrderAttribute : Attribute
    {
        public OrderAttribute(int order)
        {
            Order = order;
        }

        public int Order { get; private set; }
    }
}
