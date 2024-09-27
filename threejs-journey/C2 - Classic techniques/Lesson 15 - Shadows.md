shadow 可以分为两种：
- core shadow - 物体背面没有被光找到产生的阴影
- drop shadow - 物体遮挡关系产生的阴影

有很多实现阴影的办法，THREEjs也有内置的，方便的办法，但是这种办法并不完美。

阴影的原理：
When you do one render, Three.js will first do a render for each light supposed to cast shadows. Those renders will simulate what the light sees as if it was a camera. During these lights renders, [MeshDepthMaterial](https://threejs.org/docs/index.html#api/en/materials/MeshDepthMaterial) replaces all meshes materials.

The results are stored as textures and named shadow maps.

You won't see those shadow maps directly, but they are used on every material supposed to receive shadows and projected on the geometry.

Here's an excellent example of what the directional light and the spotlight see: [https://threejs.org/examples/webgl_shadowmap_viewer.html](https://threejs.org/examples/webgl_shadowmap_viewer.html)


Only the following types of lights support shadows:

- [PointLight](https://threejs.org/docs/index.html#api/en/lights/PointLight)
- [DirectionalLight](https://threejs.org/docs/index.html#api/en/lights/DirectionalLight)
- [SpotLight](https://threejs.org/docs/index.html#api/en/lights/SpotLight)

可选的 shadow map 算法：

Different types of algorithms can be applied to shadow maps:

- **THREE.BasicShadowMap:** Very performant but lousy quality
- **THREE.PCFShadowMap:** Less performant but smoother edges
- **THREE.PCFSoftShadowMap:** Less performant but even softer edges
- **THREE.VSMShadowMap:** Less performant, more constraints, can have unexpected results

To change it, update the `renderer.shadowMap.type` property. The default is `THREE.PCFShadowMap` but you can use `THREE.PCFSoftShadowMap` for better quality.

```javascript
const renderer = new THREE.WebGLRenderer({
    canvas: canvas
})
renderer.shadowMap.enabled = true
renderer.shadowMap.type = THREE.PCFSoftShadowMap
```

在调整camera shadow的参数的时候，可以先打开helper camera，等调整完毕以后再设定visible = false
