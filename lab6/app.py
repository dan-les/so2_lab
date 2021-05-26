from bson import ObjectId
from flask import Flask, render_template, request, redirect
from bson.json_util import dumps, loads
from pymongo import MongoClient
from flask import jsonify

app = Flask(__name__)

client = MongoClient("database", 27017)
todos = client.mymongodb.todo  

@app.route("/")
def lists():
    # Wyświetlenia listy zadań
    todos_list = todos.find()
    return render_template('index.html', todos=todos_list)


@app.route("/done")
def done():
    # Zarządzanie stanem zadania
    id = request.values.get("_id")
    task = todos.find({"_id": ObjectId(id)})
    if (task[0]["done"] == "yes"):
        todos.update({"_id": ObjectId(id)}, {"$set": {"done": "no"}})
    else:
        todos.update({"_id": ObjectId(id)}, {"$set": {"done": "yes"}})

    return redirect("/")


@app.route("/newTodo", methods=['POST'])
def action():
    # Dodawanie zadania
    name = request.values.get("name")
    desc = request.values.get("desc")
    date = request.values.get("date")
    todos.insert({"name": name, "desc": desc, "date": date, "done": "no"})
    return redirect("/")


@app.route("/remove")
def remove():
    # Usuwanie zadania
    key = request.values.get("_id")
    todos.remove({"_id": ObjectId(key)})
    return redirect("/")


@app.route("/update")
def update():
    # Przejście na stronę z aktualizacją zadania
    id = request.values.get("_id")
    task = todos.find({"_id": ObjectId(id)})
    return render_template('update.html', tasks=task)


@app.route("/changeTodo", methods=['POST'])
def action3():
    # Przesyłanie zmienionego zadania
    name = request.values.get("name")
    desc = request.values.get("desc")
    date = request.values.get("date")
    id = request.values.get("_id")
    todos.update({"_id": ObjectId(id)}, {'$set': {"name": name, "desc": desc, "date": date}})
    return redirect("/")


if __name__ == "__main__":
    app.run()
