SELECT persons.nic,
       persons.firstName,
       persons.lastName,
       properties.name
  FROM persons
       INNER JOIN
       propietaries ON propietaries.id_owner = persons.id
       INNER JOIN
       properties ON propietaries.id_property = properties.id;
