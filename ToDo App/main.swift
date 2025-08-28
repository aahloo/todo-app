import TodoAppCore

func main() {
    let app = App(useFileSystem: true) // Change to false to use InMemoryCache
    app.run()
}

main() // run the command line app
