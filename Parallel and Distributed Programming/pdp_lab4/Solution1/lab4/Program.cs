using System.Collections.Generic;
using System.Runtime.CompilerServices;

namespace lab4
{
    internal class Program
    {
        private static readonly List<string> Urls = new List<string>()
        {
            "www.cs.ubbcluj.ro/~hfpop/teaching/pfl/requirements.html",
            "www.cs.ubbcluj.ro/~forest/newton/index.html",
            "www.cs.ubbcluj.ro/~rlupsa/edu/pdp/index.html"
            
        };
        
        public static void Main(string[] args)
        {
            new Callbackk(Urls);
        }
    }
}