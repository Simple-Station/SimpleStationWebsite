---
---
async function getServerInfo(address) {
    if (!address.endsWith('/'))
        address += '/';
    if (!address.startsWith('http'))
        address = `https://${address}`;

    const endPoints = {{ site.server_endpoints | jsonify }};
    {%- comment -%} const endPoints = ['info', 'status']; {%- endcomment %}

    let promises = endPoints.map(endPoint => {
        return fetch(`${address}${endPoint}`);
    });

    let responses = await Promise.all(promises);

    let jsons = await Promise.all(responses.map(r => r.json()));

    return jsons.reduce((acc, val) => {
        return Object.assign(Object.assign({}, acc), val);
    }, {});
}
