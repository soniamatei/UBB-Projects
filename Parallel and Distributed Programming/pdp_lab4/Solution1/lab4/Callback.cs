using System;
using System.Collections.Generic;
using System.Threading;

namespace lab4
{
    public class Callbackk
    {
        private List<string> Urls { get; }
        private string ParserType => "Callback";

        public Callbackk(List<string> urls)
        {
            Urls = urls;
            Run();
        }

        private void Run()
        {
            var count = 0;
            Urls.ForEach(url => Start(Parser.Create(url, count++)));
        }

        private void Start(Parser socket)
        {
            socket.BeginConnect(HandleConnected);
            do
            {
                Thread.Sleep(100);
            }
            while (socket.Connected);
        }

        private void HandleConnected(Parser socket)
        {
            Console.WriteLine($"{ParserType}-{socket.Id}: Socket connected to {socket.BaseUrl} ({socket.UrlPath})");
            socket.BeginSend(HandleSent);
        }

        private void HandleSent(Parser socket, int numberOfSentBytes)
        {
            Console.WriteLine($"{ParserType}-{socket.Id}: Sent {numberOfSentBytes} bytes to server.");
            socket.BeginReceive(HandleReceived);
        }

        private void HandleReceived(Parser socket)
        {
            Console.WriteLine($"{ParserType}-{socket.Id}: {socket.GetResponseContent}");
            socket.ShutdownAndClose();
        }
    }
}