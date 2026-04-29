fetch('../api/produkt/get.php')
  .then(res => res.json())
  .then(data => {
    let liste = document.getElementById('liste');

    data.forEach(p => {
      let li = document.createElement('li');
      li.innerText = p.name + " - " + p.preis;
      liste.appendChild(li);
    });
  });