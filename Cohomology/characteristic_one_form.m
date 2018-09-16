function cf = characteristic_one_form(mesh, hb)
if ~exist('hb','var') || isempty(hb)
    hb = homology_basis(mesh);
end
cf = cell(size(hb));
for i = 1:length(hb)
    % slice mesh open along basis hb{i}
    bi = hb{i};
    ee = [bi,bi([2:end,1])];
    mesh2 = slice_mesh(mesh,ee);
    % construct f
    f2 = rand(mesh2.nv,1);
    bd2 = boundary(mesh2.face);
    f2(bd2{1}) = 0;
    f2(bd2{2}) = 1;
    % df is closed on original closed surface
    df2 = exterior_derivative(mesh2,f2,0);
    % map df back to original surface
    edge = mesh2.father(mesh2.edge);
    F = sparse(edge(:,1),edge(:,2),df2,mesh.nv,mesh.nv);
    F = F-F';
    df = F(mesh.edge(:,1) + mesh.nv*(mesh.edge(:,2)-1));
    cf{i} = full(df);
end
