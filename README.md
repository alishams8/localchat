# localchat

With the advent of new open-source tools like Llama 3.1, you can now build chat applications on your PC at zero cost and even run them offline.

No need for ChatGPT anymore—just kidding! Based on my tests, I still think ChatGPT is a fantastic tool, and I'll continue using it. However, it's helpful to have an offline option for chatting, right? Plus, it's always a good practice to support open-source tools, as they help promote openness and innovation in the world.

## To run your own local chat app, end-to-end:

The Makefile is set up to allow you to run your preferred model on macOS, Linux, or Windows. To install all requirements and run the app, run following command. It will get all the dependencies and start the app, in localhost:3000

```
make all
```

To run each step individually, select the corresponding tag. For example:

```
make run_frontend
```

