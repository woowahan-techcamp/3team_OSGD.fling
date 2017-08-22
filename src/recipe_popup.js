window.addEventListener("message", receiveMessage, false);

function receiveMessage(event)
{
    console.info(event);
}